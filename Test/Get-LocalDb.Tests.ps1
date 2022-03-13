#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-LocalDb' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-LocalDb )) {

        It 'Returns values' {
            $result = Get-LocalDb

            $result | Should -Not -BeNullOrEmpty
            $result.DataSource | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Not -BeNullOrEmpty
            $result.Version | Should -Not -BeNullOrEmpty
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:LocalDb = Get-LocalDb
            }

            It 'Connects by DataSource' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:LocalDb.DataSource
            }

            It 'Connects by ConnectionString' {
                $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:LocalDb.ConnectionString
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
