#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Database {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context Instance {
        BeforeAll {
            $Instance = New-SqlTestInstance
        }

        AfterAll {
            if ( $Instance ) {
                $Instance | Remove-SqlTestInstance
            }
        }

        BeforeDiscovery {
            $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context PsSqlClient -Skip:( -Not $PsSqlClient ) {

            BeforeAll {
                $InstanceConnection = $Instance | Connect-TSqlInstance
            }

            AfterAll {
                if ( $InstanceConnection ) {
                    Disconnect-TSqlInstance -Connection $InstanceConnection
                }
            }

            Context Database {
                BeforeAll {
                    $Database = New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection
                }

                AfterAll {
                    if ( $Database ) {
                        $Database | Remove-SqlTestDatabase
                    }
                }

                It 'Creates a new database' {
                    $Database | Should -Not -BeNullOrEmpty
                    $Database.ConnectionString | Should -Not -BeNullOrEmpty
                    $Database.DataSource | Should -Not -BeNullOrEmpty
                    $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                    $Database.InstanceConnection | Should -Not -BeNullOrEmpty
                }

                It 'Connects by properties' {
                    $SqlConnection = Connect-TSqlInstance `
                        -DataSource $Database.DataSource `
                        -InitialCatalog $Database.InitialCatalog `
                        -ConnectTimeout $Database.ConnectTimeout

                    $SqlConnection.Database | Should -Be $Database.InitialCatalog
                }

                It 'Connects by connection string' {
                    $SqlConnection = Connect-TSqlInstance -ConnectionString $Database.ConnectionString

                    $SqlConnection.Database | Should -Be $Database.InitialCatalog
                }

                It 'Connects by pipeline' {
                    $SqlConnection = $Database | Connect-TSqlInstance

                    $SqlConnection.Database | Should -Be $Database.InitialCatalog
                }

                AfterEach {
                    if ( $SqlConnection ) {
                        Disconnect-TSqlInstance -Connection $SqlConnection
                    }
                }
            }
        }
    }
}
