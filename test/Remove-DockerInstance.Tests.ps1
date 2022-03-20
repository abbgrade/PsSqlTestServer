#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-DockerInstance' -Tag Docker {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'Docker' -Skip:( -Not ( Test-SqlTestDocker )) {

        BeforeEach {
            $Script:Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
        }

        It 'Removes the Docker container' {
            $Script:Container | Remove-SqlTestDockerInstance

            Get-DockerContainer -Name $Script:Container.Name | Should -BeNullOrEmpty
        }
    }
}
