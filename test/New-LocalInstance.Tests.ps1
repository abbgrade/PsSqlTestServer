#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-LocalInstance' -Tag SqlLocalDB {

    BeforeDiscovery {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'LocalDb' -Skip:( -Not ( Test-SqlTestLocalDb )) {
    }

}
