#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-SqlTestInstance' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    It 'Provides a SQL server' {
        $Script:Instance = New-SqlTestInstance

        $Script:Instance | Should -Not -BeNullOrEmpty
        $Script:Instance.ConnectionString | Should -Not -BeNullOrEmpty
        $Script:Instance.DataSource | Should -Not -BeNullOrEmpty
    }

    AfterEach {
        if ( $Script:Instance ) {
            $Script:Instance | Remove-SqlTestInstance
        }
    }
}
