#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-AzureDatabase -Tag Azure {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    BeforeAll {
        $Subscription = 'Visual Studio'
    }

    Context Azure -Skip:( -Not ( Test-SqlTestAzure )) {

        Context Instance {
            BeforeAll {
                $Instance = New-SqlTestAzureInstance -Subscription $Subscription
            }

            AfterAll {
                $Instance | Remove-SqlTestAzureInstance
            }

            Context Database {

                BeforeAll {
                    $Database = New-SqlTestAzureDatabase -Instance $Instance
                }

                AfterAll {
                    $Database | Remove-SqlTestAzureDatabase
                }

                It 'Returns values' {
                    $Database | Should -Not -BeNullOrEmpty
                    $Database.DataSource | Should -Not -BeNullOrEmpty
                    $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                    $Database.ConnectTimeout | Should -Not -BeNullOrEmpty
                    $Database.ConnectionString | Should -Not -BeNullOrEmpty
                }

                BeforeDiscovery {
                    $PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
                }

                Context PsSqlClient -Skip:( -Not $PsSqlClient ) {

                    It 'Connects by pipeline' {
                        $SqlConnection = $Database | Connect-TSqlInstance -ErrorAction Stop
                    }

                    It 'Connects by DataSource' {
                        $SqlConnection = Connect-TSqlInstance `
                            -DataSource $Database.DataSource `
                            -InitialCatalog $Database.InitialCatalog `
                            -ConnectTimeout $Database.ConnectTimeout `
                            -ErrorAction Stop
                    }

                    It 'Connects by ConnectionString' {
                        $SqlConnection = Connect-TSqlInstance -ConnectionString $Database.ConnectionString -ErrorAction Stop
                    }

                    AfterEach {
                        if ( $SqlConnection ) {
                            Disconnect-TSqlInstance -Connection $SqlConnection
                        }
                    }
                }
            }
        }

        Context Database {

            BeforeAll {
                $Database = New-SqlTestAzureDatabase -Subscription $Subscription -ErrorAction Stop
            }

            AfterAll {
                $Database | Remove-SqlTestAzureDatabase
            }

            It 'Returns values' {
                $Database | Should -Not -BeNullOrEmpty
                $Database.DataSource | Should -Not -BeNullOrEmpty
                $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                $Database.ConnectTimeout | Should -Not -BeNullOrEmpty
                $Database.ConnectionString | Should -Not -BeNullOrEmpty
            }
        }
    }
}
