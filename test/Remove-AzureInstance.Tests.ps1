#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Remove-AzureInstance -Tag Azure {

    BeforeDiscovery {
        if ( Get-Module Az.Accounts -ListAvailable ) {
            Import-Module Az.Accounts
        }
        Import-Module $PSScriptRoot\..\src\PsSqlTestServer.psd1 -ErrorAction Stop
    }

    Context UnitTests -Tag UnitTest {
        It 'passes WhatIf to Azure SQL server removal' {
            # Arrange
            Mock Remove-AzSqlServer {} -ModuleName PsSqlTestServer
            $instance = [pscustomobject]@{
                ResourceGroupName = 'test-group'
                ServerName = 'test-server'
            }

            # Act
            $instance | Remove-SqlTestAzureInstance -WhatIf

            # Assert
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

            It 'Removes the Azure Instance' {
                # Arrange
                if ( -Not $AzureAvailable ) {
                    Set-ItResult -Skipped -Because 'Azure modules or an authenticated context are unavailable'
                }

                # Act
                $Instance | Remove-SqlTestAzureInstance

                # Assert
                {
                    $Instance | Get-AzSqlDatabase -ErrorAction Stop
                } | Should -Throw
            }
        }
    }
}
