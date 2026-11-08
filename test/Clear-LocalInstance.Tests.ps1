#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Clear-LocalInstance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context LocalInstance {
            BeforeEach {
                $Instance = @((New-SqlTestLocalInstance), (New-SqlTestLocalInstance))

                Import-Module PsSqlLocalDb -MinimumVersion 0.3 -ErrorAction Stop
            }

            AfterEach {
                $Instance | Remove-SqlTestLocalInstance -ErrorAction SilentlyContinue
            }

            It 'preserves matching instances when WhatIf is specified' {
                # Act
                Clear-SqlTestLocalInstance -ErrorAction Stop -WhatIf

                # Assert
                (
                    Get-LocalDbInstance |
                        Where-Object Name -in ( $Instance | Select-Object -ExpandProperty Name )
                ).Count | Should -Be $Instance.Count
            }

            It 'removes all matching test instances' {
                # Act
                Clear-SqlTestLocalInstance -ErrorAction Stop

                # Assert
                Get-LocalDbInstance |
                    Where-Object Name -in ( $Instance | Select-Object -ExpandProperty Name ) |
                    Should -BeNullOrEmpty
            }
        }
    }
}
