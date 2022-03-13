function Get-LocalDb {

    <#

    .SYNOPSIS
    Returns connection parameters to a available localDb.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

    .EXAMPLE
    PS> Get-LocalDb

    [PSCustomObject]

    Name                           Value
    ----                           -----
    DataSource                     (LocalDb)\MSSQLLocalDB
    ConnectionString               Data Source=(LocalDb)\MSSQLLocalDB;Integrated Security=True
    Version                        v11.0

    #>

    [CmdletBinding()]
    param ()

    $instanceName, $version = sqllocaldb info

    if ( -Not $instanceName ) {
        Write-Error "'sqllocaldb info' did not return a instance name"
    } else {
        Write-Verbose "Found LocalDb instance $instanceName."
    }

    if ( -Not $version ) {
        Write-Error "'sqllocaldb info' did not return a version"
    } else {
        Write-Verbose "Found LocalDb version $version."
    }

    [PSCustomObject] @{
        ConnectionString = "Data Source=(LocalDb)\$instanceName;Integrated Security=True"
        DataSource       = "(LocalDb)\$instanceName"
        Version          = $version
    } | Write-Output
}
