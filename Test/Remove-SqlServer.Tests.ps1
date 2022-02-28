#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-SqlServer' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
        Import-Module PsDocker
    }

    Context 'Container' {
        BeforeAll {
            $Script:Container = New-DockerSqlServer -AcceptEula
        }

        It 'Removes the Docker container' {
            $Script:Container | Remove-SqlServer

            Get-DockerContainer -Name $Script:Container.Name | Should -BeNullOrEmpty
        }
    }
}