#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Test-AzureSqlDatabase' {

    BeforeDiscovery {
        $Script:AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'Az.Sql' -Skip:(-Not $Script:AzSqlModule) {

        It 'works' {
            Test-AzureSqlDatabase | Should -BeIn $true, $false
        }
    }
}
