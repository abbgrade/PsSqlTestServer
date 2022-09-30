#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-AzureDatabase -Tag Azure {

    BeforeDiscovery {
        $AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
        $Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context Az -Skip:(-Not $AzSqlModule) {

        Context Instance {
            BeforeAll {
                $Instance = New-SqlTestAzureInstance -Subscription $Subscription
            }

            AfterAll {
                $Instance | Remove-SqlTestAzureInstance
            }

            Context Database {
                BeforeEach {
                    $Database = New-SqlTestAzureDatabase -Instance $Instance
                }

                It 'Removes the Azure Database' {
                    $Database | Remove-SqlTestAzureDatabase

                    {
                        $Database | Get-AzSqlDatabase -ErrorAction Stop
                    } | Should -Throw
                }
            }
        }
    }
}
