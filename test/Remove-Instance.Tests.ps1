#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-Instance {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'does not call a provider when WhatIf is specified' {
            # Arrange
            Mock Remove-LocalInstance {} -ModuleName PsSqlTestServer
            $instance = [pscustomobject]@{
                Name = 'test-instance'
                IsLocalDb = $true
            }

            # Act
            $instance | Remove-SqlTestInstance -WhatIf

            # Assert
            Should -Invoke Remove-LocalInstance -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $WhatIf
            }
        }
    }

    Context IntegrationTests -Tag IntegrationTest {
        It 'removes a created SQL server instance' {
            # Arrange
            $Instance = New-SqlTestInstance

            # Act
            $Instance | Remove-SqlTestInstance

            # Assert
            {
                $Instance | Connect-TSqlInstance -ErrorAction Stop
            } | Should -Throw
        }

        Context Docker -Tag Docker -Skip:( -Not ( Test-SqlTestDocker )) {
            BeforeEach {
                $Container = New-SqlTestDockerInstance -Port 7027 -AcceptEula
            }

            It 'removes the Docker container' {
                # Act
                $Container | Remove-SqlTestInstance

                # Assert
                Get-DockerContainer -Name $Container.Name | Should -BeNullOrEmpty
            }
        }
    }
}
