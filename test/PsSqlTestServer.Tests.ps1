#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'ModuleManifest' {

    BeforeAll {
        $ModuleManifestPath = "$PSScriptRoot\..\src\PsSqlTestServer.psd1"
        Import-Module $ModuleManifestPath
    }

    Context UnitTests -Tag UnitTest {
        It 'loads a valid module manifest' {
            # Act
            $info = Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop

            # Assert
            $info.RootModule | Should -Not -BeNullOrEmpty
            $info | Should -Not -BeNullOrEmpty
            $? | Should -Be $true
        }
    }
}
