#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-LocalInstance -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context LocalDb -Skip:( -Not ( Test-SqlTestLocalDb )) {

        It 'Provides a SQL server' {
            $Instance = New-SqlTestLocalInstance

            $Instance | Should -Not -BeNullOrEmpty
            $Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Instance.DataSource | Should -Not -BeNullOrEmpty
        }

        It 'Provides unique SQL servers' {
            $Instance = @((New-SqlTestLocalInstance), (New-SqlTestLocalInstance))
            $Instance.Count | Should -Be 2
            $Instance[0].DataSource | Should -Not -Be $Instance[1].DataSource -Because 'two instances must have unique names'
        }

        Context Version {

            BeforeAll {
                Import-Module PsSqlLocalDb -MinimumVersion 0.3
                $Version = Get-LocalDbVersion | Select-Object -First 1 -ExpandProperty Version
            }

            It 'Provides a SQL server with version' {
                $Instance = New-SqlTestLocalInstance -Version $Version

                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Not -BeNullOrEmpty
                $Instance.Version.Major | Should -Be $Version.Major
                $Instance.Version.Minor | Should -Be $Version.Minor
                $Instance.ConnectionString | Should -Not -BeNullOrEmpty
                $Instance.DataSource | Should -Not -BeNullOrEmpty
            }

            It 'Provides a SQL server with major and minor version' {
                $Instance = New-SqlTestLocalInstance -Version "$( $Version.Major ).$( $Version.Minor )"

                $Instance | Should -Not -BeNullOrEmpty
                $Instance.Version | Should -Not -BeNullOrEmpty
                $Instance.Version.Major | Should -Be $Version.Major
                $Instance.Version.Minor | Should -Be $Version.Minor
                $Instance.ConnectionString | Should -Not -BeNullOrEmpty
                $Instance.DataSource | Should -Not -BeNullOrEmpty
            }
        }

        Context PsSqlClient {

            Context Disconnected {

                BeforeAll {
                    $LocalDb = New-SqlTestLocalInstance
                }

                It 'Connects by Pipeline' {
                    $SqlConnection = $LocalDb | Connect-TSqlInstance
                    Invoke-TSqlCommand -Connection $SqlConnection -Text 'SELECT 1'
                }

                It 'Connects by DataSource' {
                    $SqlConnection = Connect-TSqlInstance -DataSource $LocalDb.DataSource -ConnectTimeout $LocalDb.ConnectTimeout
                    Invoke-TSqlCommand -Connection $SqlConnection -Text 'SELECT 1'
                }

                It 'Connects by ConnectionString' {
                    $SqlConnection = Connect-TSqlInstance -ConnectionString $LocalDb.ConnectionString
                    Invoke-TSqlCommand -Connection $SqlConnection -Text 'SELECT 1'
                }

                AfterEach {
                    if ( $SqlConnection ) {
                        Disconnect-TSqlInstance -Connection $SqlConnection
                    }
                }

            }

            Context Connected {

                BeforeAll {
                    $Instance = New-SqlTestLocalInstance -Connected
                }

                It 'is connected' {
                    ( Invoke-TSqlCommand -Connection $Instance.Connection -Text 'SELECT 1' ).Column1 | Should -Be 1
                }

            }

        }

        AfterEach {
            if ( $Instance ) {
                $Instance | Remove-SqlTestInstance
            }
        }
    }

}
