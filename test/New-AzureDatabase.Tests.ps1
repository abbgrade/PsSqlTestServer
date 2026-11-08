#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-AzureDatabase -Tag Azure {

    BeforeDiscovery {
        # PsSqlClient bundles an older Azure.Identity. Az.Accounts must load first, otherwise token acquisition fails.
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'returns a connection string with the database catalog' {
            # Arrange
            Mock New-AzSqlDatabase {
                [pscustomobject]@{
                    DatabaseName = 'test-database'
                }
            } -ModuleName PsSqlTestServer
            $server = [pscustomobject]@{
                ServerName = 'test-server'
                ResourceGroupName = 'PsSqlTestServer'
                FullyQualifiedDomainName = 'server.example.com'
            }

            # Act
            $database = New-SqlTestAzureDatabase -Server $server

            # Assert
            $database.DataSource | Should -Be 'server.example.com'
            $database.InitialCatalog | Should -Be 'test-database'
            $database.ConnectTimeout | Should -Be 30
            $database.ConnectionString | Should -Be 'Data Source=server.example.com;Connect Timeout=30;Initial Catalog=test-database'
        }

        It 'returns after a non-terminating database creation error' {
            # Arrange
            Mock New-AzSqlDatabase { Write-Error 'Database creation failed' } -ModuleName PsSqlTestServer
            $server = [pscustomobject]@{
                ServerName = 'test-server'
                ResourceGroupName = 'PsSqlTestServer'
                FullyQualifiedDomainName = 'server.example.com'
            }
            $errors = @()

            # Act
            $database = New-SqlTestAzureDatabase -Server $server -ErrorAction SilentlyContinue -ErrorVariable errors

            # Assert
            $database | Should -BeNullOrEmpty
            $errors.Count | Should -Be 1
        }
    }

    Context IntegrationTests -Tag IntegrationTest {
        BeforeAll {
            $AzureAvailable = Test-SqlTestAzure
            if ( $AzureAvailable ) {
                . $PSScriptRoot\Helper\Get-TestAzureSubscription.ps1
                . $PSScriptRoot\Helper\Get-TestAzureInstanceParameter.ps1
                $Subscription = Get-TestAzureSubscription
            }
        }

        Context Instance {
            BeforeAll {
                if ( $AzureAvailable ) {
                    $parameters = Get-TestAzureInstanceParameter
                    $Instance = New-SqlTestAzureInstance @parameters
                }
            }

            AfterAll {
                if ( $Instance ) {
                    $Instance | Remove-SqlTestAzureInstance
                }
            }

            Context Database {

                BeforeAll {
                    if ( $AzureAvailable ) {
                        $Database = New-SqlTestAzureDatabase -Instance $Instance
                    }
                }

                AfterAll {
                    if ( $Database ) {
                        $Database | Remove-SqlTestAzureDatabase
                    }
                }

                BeforeDiscovery {
                    $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
                }

                It 'returns Azure database metadata for a server' {
                    if ( -Not $AzureAvailable ) {
                        Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                    }
                    # Assert
                    $Database | Should -Not -BeNullOrEmpty
                    $Database.DataSource | Should -Not -BeNullOrEmpty
                    $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                    $Database.ConnectTimeout | Should -Not -BeNullOrEmpty
                    $Database.ConnectionString | Should -Not -BeNullOrEmpty
                }

                Context PsSqlClient -Skip:( -Not $PsSqlClient ) {
                    AfterEach {
                        if ( $SqlConnection ) {
                            Disconnect-TSqlInstance -Connection $SqlConnection
                        }
                    }

                    It 'connects using pipeline input' {
                        if ( -Not $AzureAvailable ) {
                            Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                        }
                        # Act
                        $SqlConnection = $Database | Connect-TSqlInstance -ErrorAction Stop

                        # Assert
                        $SqlConnection | Should -Not -BeNullOrEmpty
                    }

                    It 'connects using the data source' {
                        if ( -Not $AzureAvailable ) {
                            Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                        }
                        # Act
                        $SqlConnection = Connect-TSqlInstance `
                            -DataSource $Database.DataSource `
                            -InitialCatalog $Database.InitialCatalog `
                            -ConnectTimeout $Database.ConnectTimeout `
                            -ErrorAction Stop

                        # Assert
                        $SqlConnection | Should -Not -BeNullOrEmpty
                    }

                    It 'connects using the connection string' {
                        if ( -Not $AzureAvailable ) {
                            Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                        }
                        # Act
                        $SqlConnection = Connect-TSqlInstance -ConnectionString $Database.ConnectionString -ErrorAction Stop

                        # Assert
                        $SqlConnection | Should -Not -BeNullOrEmpty
                    }
                }
            }
        }

        Context Database {

            BeforeAll {
                if ( $AzureAvailable ) {
                    $Database = New-SqlTestAzureDatabase -Subscription $Subscription -ErrorAction Stop
                }
            }

            AfterAll {
                if ( $Database ) {
                    $Database | Remove-SqlTestAzureDatabase
                }
            }

            It 'returns Azure database connection metadata' {
                if ( -Not $AzureAvailable ) {
                    Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                }
                # Assert
                $Database | Should -Not -BeNullOrEmpty
                $Database.DataSource | Should -Not -BeNullOrEmpty
                $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                $Database.ConnectTimeout | Should -Not -BeNullOrEmpty
                $Database.ConnectionString | Should -Not -BeNullOrEmpty
            }
        }
    }
}
