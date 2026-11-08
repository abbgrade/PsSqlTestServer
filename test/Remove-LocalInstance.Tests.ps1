#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-LocalInstance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'passes WhatIf to LocalDB instance removal' {
            # Arrange
            Mock Import-Module { [pscustomobject]@{} } -ModuleName PsSqlTestServer
            Mock Remove-LocalDbInstance {} -ModuleName PsSqlTestServer

            # Act
            Remove-SqlTestLocalInstance -Name 'test-instance' -WhatIf

            # Assert
            Should -Invoke Remove-LocalDbInstance -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $Name -eq 'test-instance' -and $WhatIf
            }
        }
    }
}
