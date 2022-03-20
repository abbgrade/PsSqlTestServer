#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-AzureDatabase' -Tag Azure {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    BeforeAll {
        $Script:Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context 'Azure' -Skip:( -Not ( Test-SqlTestAzure )) {

        BeforeAll {
            $Script:Database = New-SqlTestAzureDatabase -Subscription $Script:Subscription -Verbose
        }

        AfterAll {
            $Script:Database | Remove-SqlTestAzureDatabase
        }

        It 'Returns values' {
            $Script:Database | Should -Not -BeNullOrEmpty
            $Script:Database.DataSource | Should -Not -BeNullOrEmpty
            $Script:Database.InitialCatalog | Should -Not -BeNullOrEmpty
            $Script:Database.ConnectTimeout | Should -Not -BeNullOrEmpty
            $Script:Database.ConnectionString | Should -Not -BeNullOrEmpty
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            It 'Connects by DataSource' {
                $Script:SqlConnection = Connect-TSqlInstance `
                    -DataSource $Script:Database.DataSource `
                    -InitialCatalog $Script:Database.InitialCatalog `
                    -ConnectTimeout $Script:Database.ConnectTimeout
            }

            It 'Connects by ConnectionString' {
                $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:Database.ConnectionString
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
