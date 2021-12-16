#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-DockerSqlServer' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop

        $Script:Container = New-DockerSqlServer -AcceptEula
    }

    It 'Returns values' {
        $Script:Container | Should -Not -BeNullOrEmpty
        $Script:Container.ConnectionString | Should -Not -BeNullOrEmpty
        $Script:Container.SecurePassword | Should -Not -BeNullOrEmpty
        $Script:Container.UserId | Should -Not -BeNullOrEmpty
    }

    AfterAll {
        $Script:Container | Remove-DockerSqlServer
    }

    BeforeDiscovery {
        $Script:PsSqlClient = Import-Module PsSqlClient -PassThru -ErrorAction SilentlyContinue
    }

    Context 'PsSqlClient' -Skip:( -Not $Script:PsSqlClient ) {
        It 'Connects by Properties' {
            $Script:SqlConnection = Connect-TSqlInstance -DataSource $Script:Container.Hostname -UserId $Script:Container.UserId -Password $Script:Container.SecurePassword -RetryCount 3
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
