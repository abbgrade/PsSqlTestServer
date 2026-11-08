#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-LocalDb -Tag SqlLocalDB {

    BeforeDiscovery {
        $PsSqlLocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.3 -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context PsSqlLocalDb -Skip:(-Not $PsSqlLocalDbModule) {

            It 'returns a boolean indicating LocalDB availability' {
                # Act
                $result = Test-SqlTestLocalDb

                # Assert
                $result | Should -BeIn $true, $false
            }
        }
    }
}
