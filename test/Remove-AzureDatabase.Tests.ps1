#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-AzureDatabase' -Tag Azure {

    BeforeDiscovery {
        $Script:AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
        $Script:Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context 'Az' -Skip:(-Not $Script:AzSqlModule) {

        Context 'Instance' {
            BeforeAll {
                $Script:Instance = New-SqlTestAzureInstance -Subscription $Script:Subscription
            }

            AfterAll {
                $Script:Instance | Remove-SqlTestAzureInstance
            }

            Context 'Database' {
                BeforeEach {
                    $Script:Database = New-SqlTestAzureDatabase -Instance $Script:Instance
                }

                It 'Removes the Azure Database' {
                    $Script:Database | Remove-SqlTestAzureDatabase

                    {
                        $Script:Database | Get-AzSqlDatabase -ErrorAction Stop
                    } | Should -Throw
                }
            }
        }
    }
}
