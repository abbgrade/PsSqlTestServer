#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-AzureSqlDatabase' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    BeforeAll {
        $Script:Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context 'AzureSqlDatabase' -Skip:( -Not ( Test-AzureSqlDatabase )) {

        It 'Returns values' {
            $result = Get-AzureSqlDatabase -Subscription $Script:Subscription -Verbose

            $result | Should -Not -BeNullOrEmpty
            $result.DataSource | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Not -BeNullOrEmpty
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:AzureSqlDatabase = Get-AzureSqlDatabase -Subscription $Script:Subscription
            }

            It 'Connects by DataSource' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:AzureSqlDatabase.DataSource -ConnectTimeout 30
            }

            It 'Connects by ConnectionString' {
                $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:AzureSqlDatabase.ConnectionString -ConnectTimeout 30
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
