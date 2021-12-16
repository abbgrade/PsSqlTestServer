#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Test-DockerSqlServer' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
        Import-Module PsDocker
    }

    It 'works' {
        Test-DockerSqlServer | Should -Be $true
    }

}
