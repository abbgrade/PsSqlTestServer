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
        [System.Version] $Version,

        # Speficies if a SqlClient connection should be created.
        [Parameter()]
        [switch] $Connected
    )

    Import-Module PsSqlLocalDb -MinimumVersion 0.4 -ErrorAction Stop

    # create instance
    $Instance = New-LocalDbInstance -Name $Name -Version:$Version

    # add metadata
    $Instance | Add-Member DataSource "(LocalDb)\$( $Instance.Name )"
    $Instance | Add-Member ConnectTimeout 30
    $Instance | Add-Member ConnectionString "Data Source=$( $Instance.DataSource );Connect Timeout=$( $Instance.ConnectTimeout );Integrated Security=True"
    $Instance | Add-Member IsLocalDb $true

    # connect instance if needed
    if ( $Connected.IsPresent ) {
        $InstanceConnection = $Instance | Connect-TSqlInstance
        if ( $InstanceConnection | Test-TSqlConnection ) {
            $Instance | Add-Member Connection $InstanceConnection
        } else {
            Write-Error "Failed to connect instance."
        }

    }

    # return
    $Instance | Write-Output
}
