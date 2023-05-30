#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe New-DockerInstance -Tag Docker {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context Docker -Skip:( -Not ( Test-SqlTestDocker )) {

        BeforeDiscovery {
            $PsSqlClient = Import-Module PsSqlClient -MinimumVersion 1.1.0 -PassThru -ErrorAction SilentlyContinue
        }

        BeforeAll {
            $Port = 7027 # just a unassigned port
            $Container = New-SqlTestDockerInstance -Port $Port -AcceptEula
        }

        AfterAll {
            if ( $Container ) {
                $Container | Remove-SqlTestDockerInstance
            }
        }

        It 'Returns values' {
            $Container | Should -Not -BeNullOrEmpty
            $Container.ConnectionString | Should -Not -BeNullOrEmpty
            $Container.DataSource | Should -Not -BeNullOrEmpty
            $Container.Port | Should -Be $Port
            $Container.SecurePassword | Should -Not -BeNullOrEmpty
            $Container.UserId | Should -Not -BeNullOrEmpty
        }

        Context PsSqlClient -Skip:( -Not $PsSqlClient ) {
            It 'Connects by Properties' {
                $SqlConnection = Connect-TSqlInstance `
                    -DataSource $Container.DataSource `
                    -Port $Container.Port `
                    -UserId $Container.UserId `
                    -Password $Container.SecurePassword `
                    -ConnectTimeout $Container.ConnectTimeout `
                    -RetryCount 3 `
                    -TrustServerCertificate:$Container.TrustServerCertificate
            }

            It 'Connects by ConnectionString' {
                $SqlConnection = Connect-TSqlInstance -ConnectionString $Container.ConnectionString
            }

            AfterEach {
                if ( $SqlConnection ) {
                    Disconnect-TSqlInstance -Connection $SqlConnection
                }
            }
        }
    }
}
