function Test-LocalDb {

    <#

    .SYNOPSIS
    Tests if a localDb-based SQL Server can be created.

    .DESCRIPTION
    Checks whether PsSqlLocalDb and the [SqlLocalDB utility](https://learn.microsoft.com/sql/tools/sqllocaldb-utility)
    are available. Writes installed LocalDB versions to verbose output.

    .EXAMPLE
    PS> Test-SqlTestLocalDb -Verbose
    Checks whether LocalDB instances can be used on this computer.
    Verbose output includes the installed LocalDB version names and numbers.
    Illustrative output: $true when the LocalDB utility is available and $false otherwise.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestLocalDb.html

    .OUTPUTS
    bool
    #>

    [CmdletBinding()]
    param ()

    $psSqlLocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.6.0 -PassThru -ErrorAction SilentlyContinue
    if ( -Not $psSqlLocalDbModule ) {
        Write-Warning 'PsSqlLocalDb is not installed in required version.'
        return $false
    }

    Write-Verbose "PsSqlLocalDb $( $psSqlLocalDbModule.Version ) is installed."
    $utilityAvailable = Test-LocalDbUtility
    if ( $utilityAvailable ) {
        foreach ( $localDbVersion in Get-LocalDbVersion ) {
            Write-Verbose "LocalDB '$($localDbVersion.Name)' version $($localDbVersion.Version) is available."
        }
    }

    return $utilityAvailable
}
