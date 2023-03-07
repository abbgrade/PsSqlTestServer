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

        AfterEach {
            if ( $Instance ) {
                $Instance | Remove-SqlTestInstance
            }
        }
    }

}
