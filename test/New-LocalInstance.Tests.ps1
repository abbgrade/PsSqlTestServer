#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-LocalInstance' -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-SqlTestLocalDb )) {

        It 'Provides a SQL server' {
            $Script:Instance = New-SqlTestLocalInstance

            $Script:Instance | Should -Not -BeNullOrEmpty
            $Script:Instance.ConnectionString | Should -Not -BeNullOrEmpty
            $Script:Instance.DataSource | Should -Not -BeNullOrEmpty
        }

        It 'Provides unique SQL servers' {
            $Script:Instance = @((New-SqlTestLocalInstance), (New-SqlTestLocalInstance))
            $Script:Instance.Count | Should -Be 2
            $Script:Instance[0].DataSource | Should -Not -Be $Script:Instance[1].DataSource -Because 'two instances must have unique names'
        }

        AfterEach {
            if ( $Script:Instance ) {
                $Script:Instance | Remove-SqlTestInstance
            }
        }
    }

}
