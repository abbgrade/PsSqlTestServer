#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-AzureInstance' -Tag Azure {

    BeforeDiscovery {
        $Script:AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
        $Script:Subscription = 'Visual Studio Enterprise – MPN'
    }

    Context 'Az' -Skip:(-Not $Script:AzSqlModule) {

        Context 'Instance' {
            BeforeAll {
                $Script:Instance = New-SqlTestAzureInstance -Subscription $Script:Subscription
            }

            It 'Removes the Azure Instance' {
                $Script:Instance | Remove-SqlTestAzureInstance

                {
                    $Script:Instance | Get-AzSqlDatabase -ErrorAction Stop
                } | Should -Throw
            }
        }
    }
}
