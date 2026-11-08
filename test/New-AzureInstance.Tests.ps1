#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-AzureInstance -Tag Azure {

    BeforeDiscovery {
        # PsSqlClient bundles an older Azure.Identity. Az.Accounts must load first, otherwise token acquisition fails.
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        BeforeEach {
            Mock Get-AzContext { @{ Account = @{ Id = 'admin@example.com' } } } -ModuleName PsSqlTestServer
            Mock Get-AzADUser { $null } -ModuleName PsSqlTestServer
            Mock Get-AzResourceGroup { @{ ResourceGroupName = 'PsSqlTestServer'; Location = 'westeurope' } } -ModuleName PsSqlTestServer
            Mock New-AzResourceGroup { @{ ResourceGroupName = 'PsSqlTestServer'; Location = $Location } } -ModuleName PsSqlTestServer
            Mock New-AzSqlServer { [pscustomobject]@{ FullyQualifiedDomainName = 'server.example.com'; ServerName = 'test' } } -ModuleName PsSqlTestServer
            Mock New-AzSqlServerFirewallRule {} -ModuleName PsSqlTestServer
        }

        It 'uses the specified location for a server in an existing group' {
            # Arrange
            $location = 'northeurope'

            # Act
            $instance = New-SqlTestAzureInstance -Location $location

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            $instance.ConnectionString | Should -Be 'Data Source=server.example.com;Connect Timeout=30;Authentication=Active Directory Integrated'
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter { $Location -eq $location }
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'uses the existing group location when no location is specified' {
            # Act
            $instance = New-SqlTestAzureInstance

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter { $Location -eq 'westeurope' }
        }

        It 'restricts the justme firewall rule to the current IPv4 address' {
            # Arrange
            Mock Invoke-WebRequest { [pscustomobject]@{ Content = "203.0.113.42`n" } } -ModuleName PsSqlTestServer

            # Act
            $instance = New-SqlTestAzureInstance -FirewallRule justme

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            Should -Invoke Invoke-WebRequest -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'https://ipv4.icanhazip.com' -and $ErrorAction -eq 'Stop'
            }
            Should -Invoke New-AzSqlServerFirewallRule -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $StartIpAddress -eq '203.0.113.42' -and $EndIpAddress -eq '203.0.113.42'
            }
        }

        It 'uses the requested location for a new group and server' {
            # Arrange
            Mock Get-AzResourceGroup { $null } -ModuleName PsSqlTestServer

            # Act
            $instance = New-SqlTestAzureInstance -Location 'northeurope'

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter { $Location -eq 'northeurope' }
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter { $Location -eq 'northeurope' }
        }

        It 'requires a location when the resource group does not exist' {
            # Arrange
            Mock Get-AzResourceGroup { $null } -ModuleName PsSqlTestServer
            $errors = @()

            # Act
            $instance = New-SqlTestAzureInstance -ErrorAction SilentlyContinue -ErrorVariable errors

            # Assert
            $instance | Should -BeNullOrEmpty
            $errors.Count | Should -Be 1
            $errors[0].ToString() | Should -BeLike "*Resource group 'PsSqlTestServer' does not exist. Specify -Location to create it.*"
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 0 -Exactly
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'terminates when caller requests terminating errors for a missing location' {
            # Arrange
            Mock Get-AzResourceGroup { $null } -ModuleName PsSqlTestServer

            # Act
            $action = { New-SqlTestAzureInstance -ErrorAction Stop }

            # Assert
            $action | Should -Throw "*Resource group 'PsSqlTestServer' does not exist. Specify -Location to create it.*"
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 0 -Exactly
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'rejects an empty location' {
            # Arrange
            $action = { New-SqlTestAzureInstance -Location '' }

            # Assert
            $action | Should -Throw
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 0 -Exactly
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'logs the server identifiers before propagating a provisioning failure' {
            # Arrange
            Mock New-Guid { [guid]'12345678-1234-1234-1234-123456789abc' } -ModuleName PsSqlTestServer
            Mock Write-Verbose {} -ModuleName PsSqlTestServer
            Mock New-AzSqlServer { throw 'Provisioning failed' } -ModuleName PsSqlTestServer

            # Act
            $action = { New-SqlTestAzureInstance -Location 'northeurope' }

            # Assert
            $action | Should -Throw '*Provisioning failed*'
            Should -Invoke Write-Verbose -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $Message -eq "Creating Azure SQL Server '12345678-1234-1234-1234-123456789abc' in resource group 'PsSqlTestServer', location 'northeurope'."
            }
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $ServerName -eq '12345678-1234-1234-1234-123456789abc' -and $Location -eq 'northeurope'
            }
            Should -Invoke New-AzSqlServerFirewallRule -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'returns after a non-terminating server provisioning error' {
            # Arrange
            Mock New-AzSqlServer { Write-Error 'Provisioning failed' } -ModuleName PsSqlTestServer
            $errors = @()

            # Act
            $instance = New-SqlTestAzureInstance -ErrorAction SilentlyContinue -ErrorVariable errors

            # Assert
            $instance | Should -BeNullOrEmpty
            $errors.Count | Should -Be 1
            Should -Invoke New-AzSqlServerFirewallRule -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

    }

    Context IntegrationTests -Tag IntegrationTest {

        BeforeAll {
            . $PSScriptRoot\Helper\Get-TestAzureSubscription.ps1
            . $PSScriptRoot\Helper\Get-TestAzureInstanceParameter.ps1
        }

        AfterEach {
            if ( $Instance ) {
                $Instance | Remove-SqlTestAzureInstance
            }
        }

        It 'creates an Azure SQL server' {
            # Arrange
            if ( -Not ( Test-SqlTestAzure ) ) {
                Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
            }
            $parameters = Get-TestAzureInstanceParameter

            # Act
            $Instance = New-SqlTestAzureInstance @parameters -ErrorAction Stop

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Instance.DataSource | Should -Not -BeNullOrEmpty
        }
    }
}
