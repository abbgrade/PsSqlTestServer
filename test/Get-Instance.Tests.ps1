#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Get-Instance' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    It 'Provides a SQL server' {
        $Script:Instance = Get-SqlTestInstance

        $Script:Instance | Should -Not -BeNullOrEmpty
        $Script:Instance.ConnectionString | Should -Not -BeNullOrEmpty
        $Script:Instance.DataSource | Should -Not -BeNullOrEmpty
    }
}
