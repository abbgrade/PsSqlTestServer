#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-LocalInstance -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb -Skip:( -Not ( Test-SqlTestLocalDb )) {

        It 'Returns values' {
            $result = Get-SqlTestLocalInstance

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 1
            $result.DataSource | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Not -BeNullOrEmpty
        }

        It 'Returns values by version' {
            $result = Get-SqlTestLocalInstance -Version 15.0

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 1
            $result.DataSource | Should -Not -BeNullOrEmpty
            $result.ConnectionString | Should -Not -BeNullOrEmpty
        }

        Context PsSqlClient {

            BeforeAll {
                $LocalDb = Get-SqlTestLocalInstance
            }

            It 'Connects by Pipeline' {
                $SqlConnection = $LocalDb | Connect-TSqlInstance
            }

            It 'Connects by DataSource' {
                $SqlConnection = Connect-TSqlInstance -DataSource $LocalDb.DataSource -ConnectTimeout $LocalDb.ConnectTimeout
            }

            It 'Connects by ConnectionString' {
                $SqlConnection = Connect-TSqlInstance -ConnectionString $LocalDb.ConnectionString
            }

            AfterEach {
                if ( $SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $SqlConnection
                }
            }
        }
    }
}
