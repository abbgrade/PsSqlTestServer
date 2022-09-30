#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Clear-LocalInstance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context LocalInstance {
        BeforeEach {
            $Instance = @((New-SqlTestLocalInstance), (New-SqlTestLocalInstance))

            Import-Module PsSqlLocalDb -MinimumVersion 0.3 -ErrorAction Stop
        }

        It Works-with-WhatIf {
            Clear-SqlTestLocalInstance -ErrorAction Stop -WhatIf

            (
                Get-LocalDbInstance |
                Where-Object Name -in ( $Instance | Select-Object -ExpandProperty Name )
            ).Count | Should -Be $Instance.Count
        }

        It Works {
            Clear-SqlTestLocalInstance -ErrorAction Stop

            Get-LocalDbInstance |
            Where-Object Name -in ( $Instance | Select-Object -ExpandProperty Name ) |
            Should -BeNullOrEmpty
        }
    }
}
