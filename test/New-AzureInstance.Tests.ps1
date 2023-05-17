#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-AzureInstance -Tag Azure {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    BeforeAll {
        $Subscription = 'Visual Studio'
    }

    Context Azure -Skip:( -Not ( Test-SqlTestAzure )) {

        It 'Provides a Azure SQL Server' {
            $Instance = New-SqlTestAzureInstance -Subscription $Subscription -ErrorAction Stop

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
