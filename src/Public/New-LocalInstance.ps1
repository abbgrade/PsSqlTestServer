function New-LocalInstance {

    <#

    .SYNOPSIS
    Creates a LocalDB instance and returns its connection parameters. Requires PsSqlLocalDb and an installed LocalDB utility.

    .DESCRIPTION
    Uses [SqlLocalDB Utility](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

    .EXAMPLE
    PS> $instance = New-SqlTestLocalInstance
    Creates a temporary LocalDB instance. The selected SQL Server version depends on the versions installed locally.
    Captured output (temporary instance name redacted; the installed version may vary):

    Name             : test-<redacted>
    Version          : 15.0.4382.1
    DataSource       : (LocalDb)\test-<redacted>
    ConnectTimeout   : 30
    ConnectionString : Data Source=(LocalDb)\test-<redacted>;Connect Timeout=30;Integrated Security=True
    IsLocalDb        : True
    PS> $instance | Remove-SqlTestLocalInstance
    Removes the LocalDB instance created by this example.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestLocalInstance.html

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

        # Specifies whether a SqlClient connection should be created.
        [Parameter()]
        [switch] $Connected
    )

    $LocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.6.0 -PassThru
    if ( -not $LocalDbModule ) {
        return
    }

    # create instance
    $Instance = New-LocalDbInstance -Name $Name -Version:$Version
    if ( -not $Instance ) {
        return
    }

    # add metadata
    $Instance | Add-Member DataSource "(LocalDb)\$( $Instance.Name )"
    $Instance | Add-Member ConnectTimeout 30
    $Instance | Add-Member ConnectionString ( New-SqlConnectionString `
            -DataSource $Instance.DataSource `
            -ConnectTimeout $Instance.ConnectTimeout `
            -Authentication 'Integrated Security=True'
    )
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
