#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'Remove-SqlServer' {

    BeforeDiscovery {
        $Script:PsDockerModule = Import-Module psdocker -PassThru -ErrorAction SilentlyContinue
    }

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlTestServer.psd1 -Force -ErrorAction Stop
    }

    Context 'PsDocker' -Skip:(-Not $Script:PsDockerModule) {

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
}
