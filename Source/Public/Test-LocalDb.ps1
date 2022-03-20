function Test-LocalDb {

    <#

    .SYNOPSIS
    Tests if a localDb-based SQL Server can be created.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15).

    .EXAMPLE
    PS> Test-SqlTestLocalDb

    True

    .OUTPUTS
    bool
    #>

    [CmdletBinding()]
    param ()

    if ( -Not ( Import-Module PsSqlLocalDb -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'PsSqlLocalDb is not installed.'
        return $false
    }

    return Test-LocalDbUtility
}
