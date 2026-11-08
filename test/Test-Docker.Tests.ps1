#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Docker {

    BeforeDiscovery {
        $PsDockerModule = Import-Module psdocker -MinimumVersion '1.10.0' -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context PsDocker -Skip:(-Not $PsDockerModule) {

            It 'returns a boolean indicating Docker availability' {
                # Act
                $result = Test-SqlTestDocker

                # Assert
                $result | Should -BeIn $true, $false
            }
        }
    }
}
