#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Database {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context Instance {
        BeforeAll {
            $Instance = New-SqlTestInstance
            $InstanceConnection = $Instance | Connect-TSqlInstance
        }

        AfterAll {
            if ( $Instance ) {
                $Instance | Remove-SqlTestInstance
            }
            if ( $InstanceConnection ) {
                Disconnect-TSqlInstance -Connection $InstanceConnection
            }
        }

        Context Database {
            BeforeEach {
                $Database = New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection
            }

            It 'Removes the database' {
                # Act
                $Database | Remove-SqlTestDatabase

                # Assert
                {
                    $SqlConnection = $Database | Connect-TSqlInstance -ErrorAction Stop
                } | Should -Throw
            }
        }
        }
    }
}
