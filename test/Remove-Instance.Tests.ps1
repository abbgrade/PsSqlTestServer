#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    It 'removes all instances' {
        $Instance = New-SqlTestInstance
        $Instance | Remove-SqlTestInstance
        {
            $Instance | Connect-TSqlInstance
        } | Should -Throw
    }

    Context Docker -Tag Docker -Skip:( -Not ( Test-SqlTestDocker )) {

        BeforeEach {
            $Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
        }

        It 'Removes the Docker container' {
            $Container | Remove-SqlTestInstance

            Get-DockerContainer -Name $Container.Name | Should -BeNullOrEmpty
        }
    }
}
