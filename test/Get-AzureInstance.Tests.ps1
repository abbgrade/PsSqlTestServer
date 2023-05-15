#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-AzureInstance -Tag Azure {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    BeforeAll {
        $Subscription = 'Visual Studio'
    }

    Context Azure -Skip:( -Not ( Test-SqlTestAzure )) {

        It 'Provides a existing Azure SQL Server' {
            $Instance = Get-SqlTestAzureInstance -Subscription $Subscription

            $Instance | Should -Not -BeNullOrEmpty
            $Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Instance.DataSource | Should -Not -BeNullOrEmpty
        }
    }

}
