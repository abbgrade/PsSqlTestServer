function New-LocalInstance {

    <#

    .SYNOPSIS
    Returns connection parameters to new localDb.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

    .EXAMPLE
    PS> New-SqlTestLocalInstance

    [PSCustomObject]

    Name                           Value
    ----                           -----
    DataSource                     (LocalDb)\test-18f57083
    ConnectionString               Data Source=(LocalDb)\test-18f57083;Integrated Security=True
    Version                        v11.0

    #>

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to create.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( New-DatabaseName ),

        # Specifies the version of the sql server.
        [Parameter()]
        [System.Version] $Version
    )

    Import-Module PsSqlLocalDb -MinimumVersion 0.3 -ErrorAction Stop

    # create instance
    if ( $Version ) {
        $instance = New-LocalDbInstance -Name $Name -Version $Version
    } else {
        $instance = New-LocalDbInstance -Name $Name
    }

    # add metadata
    $instance | Add-Member 'DataSource' "(LocalDb)\$( $instance.Name )"
    $instance | Add-Member 'ConnectTimeout' 30
    $instance | Add-Member 'ConnectionString' "Data Source=$( $instance.DataSource );Connect Timeout=$( $instance.ConnectTimeout );Integrated Security=True"
    $instance | Add-Member 'IsLocalDb' $true

    # return
    $instance | Write-Output
}
