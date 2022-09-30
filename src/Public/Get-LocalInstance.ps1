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
        # Specifies maximum number of returned instances.
        [Parameter()]
        [int] $First = 1
    )

    Import-Module PsSqlLocalDb -MinimumVersion 0.3 -ErrorAction Stop

    $selectParam = @{}
    if ( $First ) {
        $selectParam.First = $First
    }

    Get-LocalDbInstance | Select-Object @selectParam | ForEach-Object {
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
