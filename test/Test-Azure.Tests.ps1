#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Azure -Tag Azure {

    BeforeDiscovery {
        $AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context Az.Sql -Skip:(-Not $AzSqlModule) {

        It 'works' {
            Test-SqlTestAzure | Should -BeIn $true, $false
        }
    }
}
