#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-DockerInstance -Tag Docker {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context Docker -Skip:( -Not ( Test-SqlTestDocker )) {

        BeforeEach {
            $Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
        }

        It 'Removes the Docker container' {
            $Container | Remove-SqlTestDockerInstance

            Get-DockerContainer -Name $Container.Name | Should -BeNullOrEmpty
        }
    }
}
