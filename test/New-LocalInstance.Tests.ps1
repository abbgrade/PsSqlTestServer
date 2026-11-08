#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-LocalInstance -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context LocalDb -Skip:( -Not ( Test-SqlTestLocalDb )) {
            AfterEach {
                if ( $Instance ) {
                    $Instance | Remove-SqlTestInstance
                }
            }

            It 'creates a SQL server with connection metadata' {
                # Act
                $Instance = New-SqlTestLocalInstance

                # Assert
                $Instance | Should -Not -BeNullOrEmpty
                $Instance.DataSource | Should -Not -BeNullOrEmpty
                $Instance.ConnectTimeout | Should -Be 30
                $Instance.ConnectionString | Should -Be "Data Source=$($Instance.DataSource);Connect Timeout=30;Integrated Security=True"
            }

            It 'creates SQL servers with unique data sources' {
                # Act
                $Instance = @((New-SqlTestLocalInstance), (New-SqlTestLocalInstance))

                # Assert
                $Instance.Count | Should -Be 2
                $Instance[0].DataSource | Should -Not -Be $Instance[1].DataSource -Because 'two instances must have unique names'
            }

            Context Version {

                BeforeAll {
                    Import-Module PsSqlLocalDb -MinimumVersion 0.6.0
                    $Version = Get-LocalDbVersion | Select-Object -First 1 -ExpandProperty Version
                }

                It 'creates a SQL server with the selected version' {
                    # Act
                    $Instance = New-SqlTestLocalInstance -Version $Version

                    # Assert
                    $Instance | Should -Not -BeNullOrEmpty
                    $Instance.Version | Should -Not -BeNullOrEmpty
                    $Instance.Version.Major | Should -Be $Version.Major
                    $Instance.Version.Minor | Should -Be $Version.Minor
                    $Instance.ConnectionString | Should -Not -BeNullOrEmpty
                    $Instance.DataSource | Should -Not -BeNullOrEmpty
                }

                It 'accepts a major and minor version string' {
                    # Act
                    $Instance = New-SqlTestLocalInstance -Version "$( $Version.Major ).$( $Version.Minor )"

                    # Assert
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

                    AfterEach {
                        if ( $SqlConnection ) {
                            Disconnect-TSqlInstance -Connection $SqlConnection
                        }
                    }

                    It 'connects using pipeline input' {
                        # Act
                        $SqlConnection = $LocalDb | Connect-TSqlInstance

                        # Assert
                        (Invoke-TSqlCommand -Connection $SqlConnection -Text 'SELECT 1').Column1 | Should -Be 1
                    }

                    It 'connects using the data source' {
                        # Act
                        $SqlConnection = Connect-TSqlInstance -DataSource $LocalDb.DataSource -ConnectTimeout $LocalDb.ConnectTimeout

                        # Assert
                        (Invoke-TSqlCommand -Connection $SqlConnection -Text 'SELECT 1').Column1 | Should -Be 1
                    }

                    It 'connects using the connection string' {
                        # Act
                        $SqlConnection = Connect-TSqlInstance -ConnectionString $LocalDb.ConnectionString

                        # Assert
                        (Invoke-TSqlCommand -Connection $SqlConnection -Text 'SELECT 1').Column1 | Should -Be 1
                    }
                }

                Context Connected {
                    BeforeAll {
                        $Instance = New-SqlTestLocalInstance -Connected
                    }

                    It 'creates a connected SQL server instance' {
                        # Act
                        $result = Invoke-TSqlCommand -Connection $Instance.Connection -Text 'SELECT 1'

                        # Assert
                        $result.Column1 | Should -Be 1
                    }
                }
            }
        }
    }
}
