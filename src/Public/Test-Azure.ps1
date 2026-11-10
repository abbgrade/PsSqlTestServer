function Test-Azure {

    <#

    .SYNOPSIS
    Tests if a Azure-based SQL Server can be created.

    .DESCRIPTION
    Checks whether the required Az modules are installed and an Azure account is authenticated.
    Writes the version of each required Az module to verbose output.

    .EXAMPLE
    PS> Test-SqlTestAzure -Verbose
    Checks whether Azure-backed SQL Server operations can be used in the current session.
    Illustrative output includes the installed module versions and $true when requirements are met; results depend on installed modules and authentication.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestAzure.html

    .OUTPUTS
    bool

    #>

    [CmdletBinding()]
    param()

    $azAccountsModule = Import-Module Az.Accounts -PassThru -ErrorAction SilentlyContinue
    if ( -Not $azAccountsModule ) {
        Write-Warning 'Az.Accounts is not installed.'
        return $false
    }
    Write-Verbose "Az.Accounts $( $azAccountsModule.Version ) is installed."

    $azResourcesModule = Import-Module Az.Resources -PassThru -ErrorAction SilentlyContinue
    if ( -Not $azResourcesModule ) {
        Write-Warning 'Az.Resources is not installed.'
        return $false
    }
    Write-Verbose "Az.Resources $( $azResourcesModule.Version ) is installed."

    $azSqlModule = Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue
    if ( -Not $azSqlModule ) {
        Write-Warning 'Az.Sql is not installed.'
        return $false
    }
    Write-Verbose "Az.Sql $( $azSqlModule.Version ) is installed."

    if ( -Not ( Get-AzContext )) {
        Write-Warning 'Az is not logged in. Run Connect-AzAccount.'
        return $false
    }

    return $true
}
