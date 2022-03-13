#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-DockerSqlServer' {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'Docker' -Skip:( -Not ( Test-DockerSqlServer )) {

        BeforeDiscovery {
            $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
        }

        BeforeAll {
            $Script:Container = New-DockerSqlServer -AcceptEula -Verbose
        }

        AfterAll {
            if ( $Script:Container ) {
                $Script:Container | Remove-DockerSqlServer
            }
        }

        It 'Returns values' {
            $Script:Container | Should -Not -BeNullOrEmpty
            $Script:Container.ConnectionString | Should -Not -BeNullOrEmpty
            $Script:Container.DataSource | Should -Not -BeNullOrEmpty
            $Script:Container.SecurePassword | Should -Not -BeNullOrEmpty
            $Script:Container.UserId | Should -Not -BeNullOrEmpty
        }

        Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {
            It 'Connects by Properties' {
                $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:Container.DataSource -UserId $Script:Container.UserId -Password $Script:Container.SecurePassword -RetryCount 3
            }

            It 'Connects by ConnectionString' {
                $Script:SqlConnection = Connect-TSqlInstance -ConnectionString $Script:Container.ConnectionString
            }

            AfterEach {
                if ( $Script:SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $Script:SqlConnection
                }
            }
        }
    }
}
