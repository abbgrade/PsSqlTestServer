#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-DockerSqlServer' -Tag Docker {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'Docker' -Skip:( -Not ( Test-SqlTestDockerSqlServer )) {

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -MinimumVersion 1.1.0 -PassThru -ErrorAction SilentlyContinue
        }

        BeforeAll {
            $Script:Port = 7027 # just a unassigned port
            $Script:Container = New-SqlTestDockerSqlServer -Port $Script:Port -AcceptEula -Verbose
        }

        AfterAll {
            if ( $Script:Container ) {
                $Script:Container | Remove-SqlTestDockerSqlServer
            }
        }

        It 'Returns values' {
            $Script:Container | Should -Not -BeNullOrEmpty
            $Script:Container.ConnectionString | Should -Not -BeNullOrEmpty
            $Script:Container.DataSource | Should -Not -BeNullOrEmpty
            $Script:Container.Port | Should -Be $Script:Port
            $Script:Container.SecurePassword | Should -Not -BeNullOrEmpty
            $Script:Container.UserId | Should -Not -BeNullOrEmpty
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {
            It 'Connects by Properties' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:Container.DataSource -Port $Script:Container.Port -UserId $Script:Container.UserId -Password $Script:Container.SecurePassword -RetryCount 3
            }

            It 'Connects by ConnectionString' {
                $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:Container.ConnectionString -Verbose
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
