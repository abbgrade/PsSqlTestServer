function Test-LocalDb {

    <#

    .SYNOPSIS
    Tests if a localDb-based SQL Server can be created.

    .DESCRIPTION
    Checks whether PsSqlLocalDb and the [SqlLocalDB utility](https://learn.microsoft.com/sql/tools/sqllocaldb-utility)
    are available.

    .EXAMPLE
    PS> Test-SqlTestLocalDb
    Checks whether LocalDB instances can be used on this computer.
    Illustrative output: $true when the LocalDB utility is available and $false otherwise.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestLocalDb.html

    .OUTPUTS
    bool
    #>

    [CmdletBinding()]
    param ()

    if ( -Not ( Import-Module PsSqlLocalDb -MinimumVersion 0.6.0 -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'PsSqlLocalDb is not installed in required version.'
        return $false
    }

    return Test-LocalDbUtility
}
