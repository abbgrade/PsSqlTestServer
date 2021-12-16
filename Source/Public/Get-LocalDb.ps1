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

    $instanceName, $version = Invoke-Command {
        & sqllocaldb info
    }

    [PSCustomObject] @{
        ConnectionString = "Data Source=(LocalDb)\$instanceName;Integrated Security=True"
        DataSource = "(LocalDb)\$instanceName"
        Version = $version
    } | Write-Output
}
