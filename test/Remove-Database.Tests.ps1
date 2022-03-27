#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-Database' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'Instance' {
        BeforeAll {
            $Script:Instance = New-SqlTestInstance
        }

        AfterAll {
            if ( $Script:Instance ) {
                $Script:Instance | Remove-SqlTestInstance
            }
        }

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {

            BeforeAll {
                $Script:InstanceConnection = $Script:Instance | Connect-TSqlInstance
            }

            AfterAll {
                if ( $Script:InstanceConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:InstanceConnection
                }
            }

            Context 'Database' {
                BeforeEach {
                    $Script:Database = New-SqlTestDatabase -Instance $Script:Instance -InstanceConnection $Script:InstanceConnection
                }

                It 'Removes the database' {
                    $Script:Database | Remove-SqlTestDatabase

                    {
                        $Script:SqlConnection = $Script:Database | Connect-TSqlInstance
                    } | Should -Throw
                }
            }
        }
    }
}
