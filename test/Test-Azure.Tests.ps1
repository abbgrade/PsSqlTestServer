#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Test-Azure -Tag Azure {

    Context IntegrationTests -Tag IntegrationTest {
        BeforeAll {
            $AzSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
            Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
        }

        It 'returns a boolean indicating Azure availability' {
            # Arrange
            if ( -Not $AzSqlModule ) {
                Set-ItResult -Skipped -Because 'Az.Sql is unavailable'
            }

            # Act
            $result = Test-SqlTestAzure

            # Assert
            $result | Should -BeIn $true, $false
        }
    }
}
