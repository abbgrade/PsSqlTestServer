#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        AfterEach {
            if ( $Instance ) {
                $Instance | Remove-SqlTestInstance
            }
        }

        It 'creates a SQL server when a provider is available' {
            # Act
            $Instance = New-SqlTestInstance

            # Assert
            $Instance | Should -Not -BeNullOrEmpty
            $Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Instance.DataSource | Should -Not -BeNullOrEmpty
        }

        It 'creates SQL servers with unique data sources' {
            # Act
            $Instance = @((New-SqlTestInstance), (New-SqlTestInstance))

            # Assert
            $Instance.Count | Should -Be 2
            $Instance[0].DataSource | Should -Not -Be $Instance[1].DataSource -Because 'two instances must have unique names'
        }
    }
}
