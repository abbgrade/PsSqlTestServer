#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-LocalInstance' -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-SqlTestLocalDb )) {

        It 'Returns values' {
            $result = Get-SqlTestLocalInstance

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 1
            $result.DataSource | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Not -BeNullOrEmpty
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:LocalDb = Get-SqlTestLocalInstance
            }

            It 'Connects by Pipeline' {
                $Script:SqlConnection = $Script:LocalDb | Connect-TSqlInstance
            }

            It 'Connects by DataSource' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:LocalDb.DataSource -ConnectTimeout $Script:LocalDb.ConnectTimeout
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
