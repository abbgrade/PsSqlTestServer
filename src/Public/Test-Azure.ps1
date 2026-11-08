function Test-Azure {

    <#

    .SYNOPSIS
    Tests if a Azure-based SQL Server can be created.

    .DESCRIPTION
    Checks whether the required Az modules are installed and an Azure account is authenticated.

    .EXAMPLE
    PS> Test-SqlTestAzure
    Checks whether Azure-backed SQL Server operations can be used in the current session.
    Illustrative output: $true when requirements are met and $false otherwise; results depend on installed modules and authentication.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestAzure.html

    .OUTPUTS
    bool

    #>

    [CmdletBinding()]
    param()

    if ( -Not ( Import-Module Az.Accounts -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'Az.Accounts is not installed.'
        return $false
    }

    if ( -Not ( Import-Module Az.Resources -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'Az.Resources is not installed.'
        return $false
    }

    if ( -Not ( Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'Az.Sql is not installed.'
        return $false
    }

    if ( -Not ( Get-AzContext )) {
        Write-Warning 'Az is not logged in. Run Connect-AzAccount.'
        return $false
    }

    return $true
}
