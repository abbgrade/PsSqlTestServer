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

        Context PsSqlClient {

            BeforeAll {
                $InstanceConnection = $Instance | Connect-TSqlInstance
                $Instance | Add-Member Connection $InstanceConnection
            }

            AfterAll {
                if ( $InstanceConnection ) {
                    Disconnect-TSqlInstance -Connection $InstanceConnection
                }
            }

            Context Database {

                Context Disconnected {

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

                Context Connected {

                    AfterEach {
                        if ( $Database ) {
                            $Database | Remove-SqlTestDatabase
                        }
                    }

                    It 'Creates a new database with connection' {
                        $Database = New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection -Connected

                        $Database | Should -Not -BeNullOrEmpty
                        $Database.ConnectionString | Should -Not -BeNullOrEmpty
                        $Database.DataSource | Should -Not -BeNullOrEmpty
                        $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                        $Database.InstanceConnection | Should -Not -BeNullOrEmpty
                        $Database.Connection | Should -Not -BeNullOrEmpty
                        ( Invoke-TSqlCommand -Connection $Database.Connection -Text 'SELECT 1' ).Column1 | Should -Be 1
                    }

                    It 'Creates a new database with connection in pipeline' {
                        $Database = $Instance | New-SqlTestDatabase -Connected

                        $Database | Should -Not -BeNullOrEmpty
                        $Database.ConnectionString | Should -Not -BeNullOrEmpty
                        $Database.DataSource | Should -Not -BeNullOrEmpty
                        $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                        $Database.InstanceConnection | Should -Not -BeNullOrEmpty
                        $Database.Connection | Should -Not -BeNullOrEmpty
                        ( Invoke-TSqlCommand -Connection $Database.Connection -Text 'SELECT 1' ).Column1 | Should -Be 1
                    }
                }
            }
        }
    }
}
