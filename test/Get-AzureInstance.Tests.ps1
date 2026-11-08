#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-AzureInstance -Tag Azure {

    BeforeDiscovery {
        # PsSqlClient bundles an older Azure.Identity. Az.Accounts must load first, otherwise token acquisition fails.
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {

        It 'returns the expected connection metadata' {
            # Arrange
            Mock Get-AzContext {
                @{
                    Subscription = @{
                        Name = 'Test subscription'
                        Id = '00000000-0000-0000-0000-000000000001'
                    }
                }
            } -ModuleName PsSqlTestServer
            Mock Get-AzResourceGroup {
                @{ ResourceGroupName = 'PsSqlTestServer' }
            } -ModuleName PsSqlTestServer
            Mock Get-AzSqlServer {
                [pscustomobject]@{
                    FullyQualifiedDomainName = 'server.example.com'
                }
            } -ModuleName PsSqlTestServer

            # Act
            $instance = Get-SqlTestAzureInstance

            # Assert
            $instance.DataSource | Should -Be 'server.example.com'
            $instance.ConnectTimeout | Should -Be 30
            $instance.ConnectionString | Should -Be 'Data Source=server.example.com;Connect Timeout=30;Authentication=Active Directory Integrated'
        }

        It 'writes a non-terminating error when requested subscription is unavailable' {
            # Arrange
            Mock Get-AzSubscription { $null } -ModuleName PsSqlTestServer
            $errors = @()

            # Act
            $instance = Get-SqlTestAzureInstance -Subscription 'Missing subscription' -ErrorAction SilentlyContinue -ErrorVariable errors

            # Assert
            $instance | Should -BeNullOrEmpty
            $errors.Count | Should -Be 1
            $errors[0].ToString() | Should -BeLike "*Azure subscription 'Missing subscription' was not found or is not accessible to the current account.*"
            Should -Invoke Get-AzSubscription -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $SubscriptionName -eq 'Missing subscription'
            }
        }

        It 'terminates when caller requests terminating errors' {
            # Arrange
            Mock Get-AzSubscription { $null } -ModuleName PsSqlTestServer

            # Act
            $Action = { Get-SqlTestAzureInstance -Subscription 'Missing subscription' -ErrorAction Stop }

            # Assert
            $Action | Should -Throw "*Azure subscription 'Missing subscription' was not found or is not accessible to the current account.*"
        }
    }

    Context IntegrationTests -Tag IntegrationTest {

        BeforeAll {
            . $PSScriptRoot\Helper\Get-TestAzureSubscription.ps1
            . $PSScriptRoot\Helper\Get-TestAzureInstanceParameter.ps1
        }

        AfterEach {
            if ( $CreatedInstance ) {
                $CreatedInstance | Remove-SqlTestAzureInstance
            }
        }

        It 'returns an existing Azure SQL server' {
            # Arrange
            if ( -Not ( Test-SqlTestAzure ) ) {
                Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
            }
            $parameters = Get-TestAzureInstanceParameter
            $CreatedInstance = New-SqlTestAzureInstance @parameters

            # Act
            $Instance = Get-SqlTestAzureInstance -Subscription $parameters.Subscription

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Instance.DataSource | Should -Not -BeNullOrEmpty
        }
    }

}
