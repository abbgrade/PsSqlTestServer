#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-LocalInstance -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context LocalDb -Skip:( -Not ( Test-SqlTestLocalDb )) {

            It 'returns local instance connection metadata' {
                # Act
                $result = Get-SqlTestLocalInstance

                # Assert
                $result | Should -Not -BeNullOrEmpty
                $result.Count | Should -Be 1
                $result.DataSource | Should -Not -BeNullOrEmpty
                $result.ConnectTimeout | Should -Be 30
                $result.ConnectionString | Should -Be "Data Source=$($result.DataSource);Connect Timeout=30;Integrated Security=True"
            }

            It 'returns local instance metadata filtered by version' {
                # Act
                $result = Get-SqlTestLocalInstance -Version 15.0

                # Assert
                $result | Should -Not -BeNullOrEmpty
                $result.Count | Should -Be 1
                $result.DataSource | Should -Not -BeNullOrEmpty
                $result.ConnectionString | Should -Not -BeNullOrEmpty
            }

            Context PsSqlClient {

                BeforeAll {
                    $LocalDb = Get-SqlTestLocalInstance
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
                    $SqlConnection | Should -Not -BeNullOrEmpty
                }

                It 'connects using the data source' {
                    # Act
                    $SqlConnection = Connect-TSqlInstance -DataSource $LocalDb.DataSource -ConnectTimeout $LocalDb.ConnectTimeout

                    # Assert
                    $SqlConnection | Should -Not -BeNullOrEmpty
                }

                It 'connects using the connection string' {
                    # Act
                    $SqlConnection = Connect-TSqlInstance -ConnectionString $LocalDb.ConnectionString

                    # Assert
                    $SqlConnection | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
