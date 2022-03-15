#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Test-LocalDb' {

    BeforeDiscovery {
        $Script:PsSqlLocalDbModule = Import-Module PsSqlLocalDb -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'PsSqlLocalDb' -Skip:(-Not $Script:PsSqlLocalDbModule) {

        It 'works' {
            Test-LocalDb | Should -BeIn $true, $false
        }
    }
}
