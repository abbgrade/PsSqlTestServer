#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-Instance' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    It 'removes all instances' {
        $Script:Instance = New-SqlTestInstance
        $Script:Instance | Remove-SqlTestInstance
        {
            $Script:Instance | Connect-TSqlInstance
        } | Should -Throw
    }

    Context 'Docker' -Tag 'Docker' -Skip:( -Not ( Test-SqlTestDocker )) {

        BeforeEach {
            $Script:Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
        }

        It 'Removes the Docker container' {
            $Script:Container | Remove-SqlTestInstance

            Get-DockerContainer -Name $Script:Container.Name | Should -BeNullOrEmpty
        }
    }
}
