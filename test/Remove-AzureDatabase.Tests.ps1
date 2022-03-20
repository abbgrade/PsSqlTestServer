#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-AzureDatabase' -Tag Azure {

    BeforeDiscovery {
        $Script:AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
        $Script:Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context 'Az' -Skip:(-Not $Script:AzSqlModule) {

        Context 'Container' {
            BeforeAll {
                $Script:Container = New-SqlTestAzureDatabase -Subscription $Script:Subscription
            }

            It 'Removes the Azure container' {
                $Script:Container | Remove-SqlTestAzureDatabase

                {
                    $Script:Container | Get-AzSqlDatabase -ErrorAction Stop
                } | Should -Throw
            }
        }
    }
}
