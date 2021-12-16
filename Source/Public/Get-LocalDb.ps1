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
    DataSource                     MSSQLLocalDB
    ConnectionString               Data Source=MSSQLLocalDB;Integrated Security=True
    Version                        v11.0

    #>

    [CmdletBinding()]
    param ()

    $instanceName, $version = Invoke-Command {
        & sqllocaldb info
    }

    Write-Output [PSCustomObject] @{
        ConnectionString = "Data Source=$instanceName;Integrated Security=True"
        DataSource = $instanceName
        Version = $version
    }
}
