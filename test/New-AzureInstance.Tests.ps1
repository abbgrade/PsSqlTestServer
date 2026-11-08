#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-AzureInstance -Tag Azure {

    BeforeDiscovery {
        # PsSqlClient bundles an older Azure.Identity. Az.Accounts must load first, otherwise token acquisition fails.
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
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
            # Act
            $instance = New-SqlTestAzureInstance -Location 'northeurope'

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter { $Location -eq 'northeurope' }
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'uses the existing group location when no location is specified' {
            # Act
            $instance = New-SqlTestAzureInstance

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter { $Location -eq 'westeurope' }
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

            # Act
            $action = { New-SqlTestAzureInstance }

            # Assert
            $action | Should -Throw "*Resource group 'PsSqlTestServer' does not exist. Specify -Location to create it.*"
            Should -Invoke New-AzResourceGroup -ModuleName PsSqlTestServer -Times 0 -Exactly
            Should -Invoke New-AzSqlServer -ModuleName PsSqlTestServer -Times 0 -Exactly
        }

        It 'rejects an empty location' {
            # Act
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
    }

    Context IntegrationTests -Tag IntegrationTest {

        BeforeAll {
            . $PSScriptRoot\Helper\Get-TestAzureSubscription.ps1
            . $PSScriptRoot\Helper\Get-TestAzureInstanceParameter.ps1
        }

        It 'Provides a Azure SQL Server' {
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

        AfterEach {
            if ( $Instance ) {
                $Instance | Remove-SqlTestAzureInstance
            }
        }
    }
}
