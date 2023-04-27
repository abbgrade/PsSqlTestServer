function Get-LocalInstance {

    <#

    .SYNOPSIS
    Returns connection parameters to a available localDb.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

    .EXAMPLE
    PS> Get-SqlTestLocalInstance

    [PSCustomObject]

    Name                           Value
    ----                           -----
    DataSource                     (LocalDb)\MSSQLLocalDB
    ConnectionString               Data Source=(LocalDb)\MSSQLLocalDB;Integrated Security=True
    Version                        v11.0

    #>

    [CmdletBinding()]
    param (
        # Specifies maximum number of returned sql server instances.
        [Parameter()]
        [int] $First = 1,

        # Filters the version of the returned sql server instance.
        [Parameter()]
        [System.Version] $Version
    )

    Import-Module PsSqlLocalDb -MinimumVersion 0.4 -ErrorAction Stop

    $selectParam = @{}
    if ( $First ) {
        $selectParam.First = $First
    }

    Get-LocalDbInstance -Version:$Version | Select-Object @selectParam | ForEach-Object {
        $instance = $PSItem

        # add metadata
        $instance | Add-Member 'DataSource' "(LocalDb)\$( $instance.Name )"
        $instance | Add-Member 'ConnectTimeout' 30
        $instance | Add-Member 'ConnectionString' "Data Source=$( $instance.DataSource );Connect Timeout=$( $instance.ConnectTimeout );Integrated Security=True"
        $instance | Add-Member 'IsLocalDb' $true

        # return
        $instance | Write-Output
    }
}
