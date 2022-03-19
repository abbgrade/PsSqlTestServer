#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-SqlServer' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    It 'Provides a SQL server' {
        $server = New-SqlServer -Verbose

        $server | Should -Not -BeNullOrEmpty
        $server.ConnectionString | Should -Not -BeNullOrEmpty
        $server.DataSource | Should -Not -BeNullOrEmpty
    }
}