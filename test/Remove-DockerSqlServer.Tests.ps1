#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-DockerInstance' -Tag Docker {

    BeforeDiscovery {
        $Script:PsDockerModule = Import-Module psdocker -MinimumVersion '1.7.0' -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'PsDocker' -Skip:(-Not $Script:PsDockerModule) {

        Context 'Container' {
            BeforeAll {
                $Script:Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
            }

            It 'Removes the Docker container' {
                $Script:Container | Remove-SqlTestDockerInstance

                Get-DockerContainer -Name $Script:Container.Name | Should -BeNullOrEmpty
            }
        }
    }
}
