#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-AzureInstance' -Tag Azure {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    BeforeAll {
        $Script:Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context 'Azure' -Skip:( -Not ( Test-SqlTestAzure )) {

        It 'Provides a Azure SQL Server' {
            $Script:Instance = New-SqlTestAzureInstance -Subscription $Script:Subscription

            $Script:Instance | Should -Not -BeNullOrEmpty
            $Script:Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Script:Instance.DataSource | Should -Not -BeNullOrEmpty
        }

        AfterEach {
            $Script:Instance | Remove-SqlTestAzureInstance
        }
    }
}
