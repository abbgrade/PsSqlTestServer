#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-Database' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'Instance' {
        BeforeAll {
            $Script:Instance = New-SqlTestInstance
        }

        AfterAll {
            if ( $Script:Instance ) {
                $Script:Instance | Remove-SqlTestInstance
            }
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:InstanceConnection = $Script:Instance | Connect-TSqlInstance
            }

            AfterAll {
                if ( $Script:InstanceConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:InstanceConnection
                }
            }

            Context 'Database' {
                BeforeAll {
                    $Script:Database = New-SqlTestDatabase -Instance $Script:Instance -InstanceConnection $Script:InstanceConnection
                }

                AfterAll {
                    if ( $Script:Database ) {
                        $Script:Database | Remove-SqlTestDatabase
                    }
                }

                It 'Creates a new database' {
                    $Script:Database | Should -Not -BeNullOrEmpty
                    $Script:Database.ConnectionString | Should -Not -BeNullOrEmpty
                    $Script:Database.DataSource | Should -Not -BeNullOrEmpty
                    $Script:Database.InitialCatalog | Should -Not -BeNullOrEmpty
                    $Script:Database.InstanceConnection | Should -Not -BeNullOrEmpty
                }

                It 'Connects by properties' {
                    $Script:SqlConnection = Connect-TSqlInstance `
                        -DataSource $Script:Database.DataSource `
                        -InitialCatalog $Script:Database.InitialCatalog `
                        -ConnectTimeout $Script:Database.ConnectTimeout

                    $Script:SqlConnection.Database | Should -Be $Script:Database.InitialCatalog
                }

                It 'Connects by connection string' {
                    $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:Database.ConnectionString

                    $Script:SqlConnection.Database | Should -Be $Script:Database.InitialCatalog
                }

                It 'Connects by pipeline' {
                    $Script:SqlConnection = $Script:Database | Connect-TSqlInstance

                    $Script:SqlConnection.Database | Should -Be $Script:Database.InitialCatalog
                }

                AfterEach {
                    if ( $Script:SqlConnection ) {
                        Disconnect-TSqlInstance -Connection $Script:SqlConnection
                    }
                }
            }
        }
    }
}
