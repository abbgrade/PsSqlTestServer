#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-AzureInstance -Tag Azure {

    BeforeDiscovery {
        # PsSqlClient bundles an older Azure.Identity. Az.Accounts must load first, otherwise token acquisition fails.
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {

        It 'throws when requested subscription is unavailable' {
            # Arrange
            Mock Get-AzSubscription { $null } -ModuleName PsSqlTestServer

            # Act
            $Action = { Get-SqlTestAzureInstance -Subscription 'Missing subscription' }

            # Assert
            $Action | Should -Throw "*Azure subscription 'Missing subscription' was not found or is not accessible to the current account.*"
            Should -Invoke Get-AzSubscription -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $SubscriptionName -eq 'Missing subscription'
            }
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

        It 'Provides a existing Azure SQL Server' {
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
