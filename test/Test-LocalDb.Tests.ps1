#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-LocalDb -Tag SqlLocalDB {

    BeforeDiscovery {
        $PsSqlLocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.3 -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context PsSqlLocalDb -Skip:(-Not $PsSqlLocalDbModule) {

        It 'works' {
            Test-SqlTestLocalDb | Should -BeIn $true, $false
        }
    }
}
