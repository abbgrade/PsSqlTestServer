#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-DockerInstance -Tag Docker {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context IntegrationTests -Tag IntegrationTest {
        Context Docker -Tag Docker -Skip:( -Not ( Test-SqlTestDocker )) {

        BeforeEach {
            $Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
        }

            It 'removes the Docker container' {
                # Act
                $Container | Remove-SqlTestDockerInstance

                # Assert
                Get-DockerContainer -Name $Container.Name | Should -BeNullOrEmpty
            }
        }
    }
}
