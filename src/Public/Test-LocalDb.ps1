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

    if ( -Not ( Import-Module PsSqlLocalDb -MinimumVersion 0.4 -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'PsSqlLocalDb is not installed in required version.'
        return $false
    }

    return Test-LocalDbUtility
}
