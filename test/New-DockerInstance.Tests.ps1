#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-DockerInstance {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'passes container name and timeout separately to readiness check' {
            # Arrange
            Mock Get-DockerVersion {
                [pscustomobject]@{
                    Server = @{
                        Engine = @{
                            OSArch = 'linux/amd64'
                        }
                    }
                }
            } -ModuleName PsSqlTestServer
            Mock New-DockerContainer {
                [pscustomobject]@{
                    Name = 'test-container'
                }
            } -ModuleName PsSqlTestServer
            Mock Wait-LinuxDockerSqlServer {} -ModuleName PsSqlTestServer

            # Act
            $container = New-SqlTestDockerInstance -DockerContainerName 'test-container' -AcceptEula -Timeout 7

            # Assert
            $container.Name | Should -Be 'test-container'
            Should -Invoke Wait-LinuxDockerSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $Name -eq 'test-container' -and $Timeout -eq 7
            }
        }

        It 'writes a non-terminating error when the EULA is not accepted' {
            # Arrange
            $errors = @()

            # Act
            $container = New-SqlTestDockerInstance -AcceptEula:$false -ErrorAction SilentlyContinue -ErrorVariable errors

            # Assert
            $container | Should -BeNullOrEmpty
            $errors.Count | Should -Be 1
            $errors[0].ToString() | Should -BeLike '*Accept the Microsoft EULA with -AcceptEula*'
        }

        It 'terminates when caller requests terminating errors for an unaccepted EULA' {
            # Arrange
            $action = { New-SqlTestDockerInstance -AcceptEula:$false -ErrorAction Stop }

            # Act
            $caughtError = $null
            try {
                & $action
            }
            catch {
                $caughtError = $_
            }

            # Assert
            $caughtError | Should -Not -BeNullOrEmpty
            $caughtError.ToString() | Should -BeLike '*Accept the Microsoft EULA with -AcceptEula*'
        }
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context Docker -Tag Docker -Skip:( -Not ( Test-SqlTestDocker )) {

            BeforeDiscovery {
                $PsSqlClient = Import-Module PsSqlClient -MinimumVersion 2.0.0 -PassThru -ErrorAction SilentlyContinue
            }

            BeforeAll {
                $PortListener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, 0)
                $PortListener.Start()
                $Port = $PortListener.LocalEndpoint.Port
                $PortListener.Stop()
                $Container = New-SqlTestDockerInstance -Port $Port -AcceptEula
            }

            AfterAll {
                if ( $Container ) {
                    $Container | Remove-SqlTestDockerInstance
                }
            }

            It 'returns Docker connection metadata' {
                # Assert
                $Container | Should -Not -BeNullOrEmpty
                $Container.ConnectionString | Should -Not -BeNullOrEmpty
                $Container.DataSource | Should -Not -BeNullOrEmpty
                $Container.Port | Should -Be $Port
                $Container.SecurePassword | Should -Not -BeNullOrEmpty
                $Container.UserId | Should -Not -BeNullOrEmpty
            }

            Context PsSqlClient -Skip:( -Not $PsSqlClient ) {
                AfterEach {
                    if ( $SqlConnection ) {
                        Disconnect-TSqlInstance -Connection $SqlConnection
                    }
                }

                It 'connects using instance properties' {
                    # Act
                    $SqlConnection = Connect-TSqlInstance `
                    -DataSource $Container.DataSource `
                    -Port $Container.Port `
                    -UserId $Container.UserId `
                    -Password $Container.SecurePassword `
                    -ConnectTimeout $Container.ConnectTimeout `
                    -RetryCount 3 `
                    -TrustServerCertificate:$Container.TrustServerCertificate

                    # Assert
                    $SqlConnection | Should -Not -BeNullOrEmpty
                    $SqlConnection | Test-TSqlConnection | Should -BeTrue
                }

                It 'connects using the connection string' {
                    # Act
                    $SqlConnection = Connect-TSqlInstance -ConnectionString $Container.ConnectionString

                    # Assert
                    $SqlConnection | Should -Not -BeNullOrEmpty
                    $SqlConnection | Test-TSqlConnection | Should -BeTrue
                }
            }
        }
    }
}
