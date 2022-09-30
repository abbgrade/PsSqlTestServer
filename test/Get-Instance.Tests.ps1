#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Get-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    It 'Provides a SQL server' {
        $Instance = Get-SqlTestInstance

        $Instance | Should -Not -BeNullOrEmpty
        $Instance.ConnectionString | Should -Not -BeNullOrEmpty
        $Instance.DataSource | Should -Not -BeNullOrEmpty
    }
}
