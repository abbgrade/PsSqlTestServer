#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-DockerInstance -Tag Docker {

    BeforeDiscovery {
        if ( Get-Module psdocker -ListAvailable ) {
            Import-Module psdocker -ErrorAction SilentlyContinue
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest -Skip:( -Not ( Get-Module psdocker -ListAvailable | Where-Object Version -GE ([version]'1.10.0') )) {
        It 'passes WhatIf to the Docker container removal command' {
            # Arrange
            Mock Import-Module { [pscustomobject]@{} } -ModuleName PsSqlTestServer
            Mock Remove-DockerContainer {} -ModuleName PsSqlTestServer
            $container = [pscustomobject]@{ Name = 'test-container' }

            # Act
            $container | Remove-SqlTestDockerInstance -WhatIf

            # Assert
            Should -Invoke Remove-DockerContainer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $Name -eq 'test-container' -and $WhatIf
            }
        }
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
