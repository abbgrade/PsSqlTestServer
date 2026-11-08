#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Clear-LocalInstance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'passes WhatIf through to each LocalDB removal' {
            # Arrange
            Mock Import-Module { [pscustomobject]@{} } -ModuleName PsSqlTestServer
            Mock Get-LocalInstance { [pscustomobject]@{ Name = 'test-instance' } } -ModuleName PsSqlTestServer
            Mock Remove-LocalInstance {} -ModuleName PsSqlTestServer

            # Act
            Clear-SqlTestLocalInstance -WhatIf

            # Assert
            Should -Invoke Import-Module -ModuleName PsSqlTestServer -Times 1
            Should -Invoke Get-LocalInstance -ModuleName PsSqlTestServer -Times 1
            Should -Invoke Remove-LocalInstance -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $Name -eq 'test-instance' -and $WhatIf
            }
        }
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context LocalInstance {
            BeforeEach {
                $Instance = @((New-SqlTestLocalInstance), (New-SqlTestLocalInstance))

                Import-Module PsSqlLocalDb -MinimumVersion 0.6.0 -ErrorAction Stop
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
