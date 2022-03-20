#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Test-Docker' -Tag Docker {

    BeforeDiscovery {
        $Script:PsDockerModule = Import-Module psdocker -MinimumVersion '1.7.0' -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'PsDocker' -Skip:(-Not $Script:PsDockerModule) {

        It 'works' {
            Test-SqlTestDocker | Should -Be $true
        }
    }
}
