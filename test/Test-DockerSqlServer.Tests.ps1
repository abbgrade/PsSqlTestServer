#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Docker -Tag Docker {

    BeforeDiscovery {
        $PsDockerModule = Import-Module psdocker -MinimumVersion '1.7.0' -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context PsDocker -Skip:(-Not $PsDockerModule) {

        It 'works' {
            Test-SqlTestDocker | Should -BeIn $true, $false
        }
    }
}
