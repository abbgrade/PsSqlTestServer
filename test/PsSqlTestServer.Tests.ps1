#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'ModuleManifest' {

    BeforeAll {
        $ModuleManifestPath = "$PSScriptRoot\..\src\PsSqlTestServer.psd1"
        Import-Module $ModuleManifestPath -Force
    }

    It 'is valid' {
        $info = Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop
        $info.RootModule | Should -Not -BeNullOrEmpty
        $info | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}
