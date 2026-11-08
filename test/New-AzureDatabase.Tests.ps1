#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-AzureDatabase -Tag Azure {

    BeforeDiscovery {
        # PsSqlClient bundles an older Azure.Identity. Az.Accounts must load first, otherwise token acquisition fails.
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
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

                It 'Returns values' {
                    if ( -Not $AzureAvailable ) {
                        Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                    }
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
                        if ( -Not $AzureAvailable ) {
                            Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                        }
                        $SqlConnection = $Database | Connect-TSqlInstance -ErrorAction Stop
                    }

                    It 'Connects by DataSource' {
                        if ( -Not $AzureAvailable ) {
                            Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                        }
                        $SqlConnection = Connect-TSqlInstance `
                            -DataSource $Database.DataSource `
                            -InitialCatalog $Database.InitialCatalog `
                            -ConnectTimeout $Database.ConnectTimeout `
                            -ErrorAction Stop
                    }

                    It 'Connects by ConnectionString' {
                        if ( -Not $AzureAvailable ) {
                            Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                        }
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
                if ( $AzureAvailable ) {
                    $Database = New-SqlTestAzureDatabase -Subscription $Subscription -ErrorAction Stop
                }
            }

            AfterAll {
                if ( $Database ) {
                    $Database | Remove-SqlTestAzureDatabase
                }
            }

            It 'Returns values' {
                if ( -Not $AzureAvailable ) {
                    Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                }
                $Database | Should -Not -BeNullOrEmpty
                $Database.DataSource | Should -Not -BeNullOrEmpty
                $Database.InitialCatalog | Should -Not -BeNullOrEmpty
                $Database.ConnectTimeout | Should -Not -BeNullOrEmpty
                $Database.ConnectionString | Should -Not -BeNullOrEmpty
            }
        }
    }
}
