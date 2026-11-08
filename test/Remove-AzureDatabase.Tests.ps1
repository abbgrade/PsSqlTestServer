#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-AzureDatabase -Tag Azure {

    BeforeDiscovery {
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'passes WhatIf to Azure SQL database and server removal' {
            # Arrange
            Mock Remove-AzSqlDatabase {} -ModuleName PsSqlTestServer
            Mock Remove-AzSqlServer {} -ModuleName PsSqlTestServer
            $database = [pscustomobject]@{
                ResourceGroupName = 'test-group'
                ServerName = 'test-server'
                DatabaseName = 'test-database'
                RemoveServer = $true
            }

            # Act
            $database | Remove-SqlTestAzureDatabase -WhatIf

            # Assert
            Should -Invoke Remove-AzSqlDatabase -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $WhatIf -and $Confirm -eq $false
            }
            Should -Invoke Remove-AzSqlServer -ModuleName PsSqlTestServer -Times 1 -Exactly -ParameterFilter {
                $WhatIf -and $Confirm -eq $false
            }
        }
    }

    Context IntegrationTests -Tag IntegrationTest {
        BeforeAll {
            if ( Get-Module Az.Accounts -ListAvailable ) {
                Import-Module Az.Accounts
            }
            Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
            $AzureAvailable = Test-SqlTestAzure
            if ( $AzureAvailable ) {
                . $PSScriptRoot\Helper\Get-TestAzureSubscription.ps1
                . $PSScriptRoot\Helper\Get-TestAzureInstanceParameter.ps1
            }
        }

        Context Instance {
            BeforeAll {
                if ( $AzureAvailable ) {
                    $parameters = Get-TestAzureInstanceParameter
                    $Instance = New-SqlTestAzureInstance @parameters
                }
            }

            AfterAll {
                if ( $Instance ) {
                    $Instance | Remove-SqlTestAzureInstance
                }
            }

            Context Database {
                BeforeEach {
                    if ( $AzureAvailable ) {
                        $Database = New-SqlTestAzureDatabase -Instance $Instance
                    }
                }

                It 'Removes the Azure Database' {
                    # Arrange
                    if ( -Not $AzureAvailable ) {
                        Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                    }

                    # Act
                    $Database | Remove-SqlTestAzureDatabase

                    # Assert
                    {
                        $Database | Get-AzSqlDatabase -ErrorAction Stop
                    } | Should -Throw
                }
            }
        }
    }
}
