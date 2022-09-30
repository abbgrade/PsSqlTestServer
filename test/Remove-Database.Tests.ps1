#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Database {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

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
                $Database | Remove-SqlTestDatabase

                {
                    $SqlConnection = $Database | Connect-TSqlInstance
                } | Should -Throw
            }
        }
    }
}
