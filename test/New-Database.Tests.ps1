#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Database {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'does not create a database when WhatIf is specified' {
            # Arrange
            Mock Invoke-TSqlCommand {} -ModuleName PsSqlTestServer
            $instance = [pscustomobject]@{
                Name = 'test-instance'
                ConnectionString = 'Data Source=localhost;Integrated Security=True'
            }
            $connection = [Microsoft.Data.SqlClient.SqlConnection]::new()

            # Act
            $database = New-SqlTestDatabase -Instance $instance -InstanceConnection $connection -Name 'test-database' -WhatIf

            # Assert
            $database | Should -BeNullOrEmpty
            Should -Invoke Invoke-TSqlCommand -ModuleName PsSqlTestServer -Times 0
        }
    }

    Context IntegrationTests -Tag IntegrationTest {
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

                    AfterEach {
                        if ( $SqlConnection ) {
                            Disconnect-TSqlInstance -Connection $SqlConnection
                        }
                    }

                    It 'creates a new database' {
                        # Assert
                        $Database | Should -Not -BeNullOrEmpty
                        $Database.ConnectionString | Should -Not -BeNullOrEmpty
                        $Database.DataSource | Should -Not -BeNullOrEmpty
                        $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                        $Database.InstanceConnection | Should -Not -BeNullOrEmpty
                        $Database.ConnectionString | Should -Be "$($Instance.ConnectionString);Initial Catalog=$($Database.InitialCatalog)"
                    }

                    It 'connects using database properties' {
                        # Act
                        $SqlConnection = Connect-TSqlInstance `
                            -DataSource $Database.DataSource `
                            -InitialCatalog $Database.InitialCatalog `
                            -ConnectTimeout $Database.ConnectTimeout

                        # Assert
                        $SqlConnection.Database | Should -Be $Database.InitialCatalog
                        $SqlConnection | Test-TSqlConnection | Should -Be $true
                    }

                    It 'connects using the database connection string' {
                        # Act
                        $SqlConnection = Connect-TSqlInstance -ConnectionString $Database.ConnectionString

                        # Assert
                        $SqlConnection.Database | Should -Be $Database.InitialCatalog
                        $SqlConnection | Test-TSqlConnection | Should -Be $true
                    }

                    It 'connects using pipeline input' {
                        # Act
                        $SqlConnection = $Database | Connect-TSqlInstance

                        # Assert
                        $SqlConnection.Database | Should -Be $Database.InitialCatalog
                        $SqlConnection | Test-TSqlConnection | Should -Be $true
                    }
                }

                Context Connected {

                    AfterEach {
                        if ( $Database ) {
                            $Database | Remove-SqlTestDatabase
                        }
                    }

                    It 'creates a database with an open connection' {
                        # Act
                        $Database = New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection -Connected

                        # Assert
                        $Database | Should -Not -BeNullOrEmpty
                        $Database.ConnectionString | Should -Not -BeNullOrEmpty
                        $Database.DataSource | Should -Not -BeNullOrEmpty
                        $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                        $Database.InstanceConnection | Should -Not -BeNullOrEmpty
                        $Database.Connection | Should -Not -BeNullOrEmpty

                        $Database.Connection | Test-TSqlConnection | Should -Be $true
                    }

                    It 'creates a database with an open connection from pipeline input' {
                        # Act
                        $Database = $Instance | New-SqlTestDatabase -Connected

                        # Assert
                        $Database | Should -Not -BeNullOrEmpty
                        $Database.ConnectionString | Should -Not -BeNullOrEmpty
                        $Database.DataSource | Should -Not -BeNullOrEmpty
                        $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                        $Database.InstanceConnection | Should -Not -BeNullOrEmpty
                        $Database.Connection | Should -Not -BeNullOrEmpty

                        $Database.Connection | Test-TSqlConnection | Should -Be $true
                    }
                }
                }
            }
        }
    }
}
