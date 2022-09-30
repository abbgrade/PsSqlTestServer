#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-AzureInstance -Tag Azure {

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

            It 'Removes the Azure Instance' {
                $Instance | Remove-SqlTestAzureInstance

                {
                    $Instance | Get-AzSqlDatabase -ErrorAction Stop
                } | Should -Throw
            }
        }
    }
}
