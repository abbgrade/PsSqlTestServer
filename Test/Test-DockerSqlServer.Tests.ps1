#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Test-DockerSqlServer' {

    BeforeDiscovery {
        $Script:PsDockerModule = Import-Module psdocker -PassThru
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'PsDocker' -Skip:(-Not $Script:PsDockerModule) {

        It 'works' {
            Test-DockerSqlServer | Should -Be $true
        }
    }
}
