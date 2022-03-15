function Test-LocalDb {

    <#

    .SYNOPSIS
    Tests if a localDb-based SQL Server can be created.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15).

    .EXAMPLE
    PS> Test-LocalDb

    True

    .OUTPUTS
    bool
    #>

    [CmdletBinding()]
    param ()

    $psSqlLocalDbModule = Import-Module PsSqlLocalDb -PassThru -ErrorAction SilentlyContinue

    if ( $psSqlLocalDbModule ) {
        Write-Verbose "PsLocalDb $( $psSqlLocalDbModule.Version ) is installed."
        return Test-LocalDbUtility
    }

    return $false
}
