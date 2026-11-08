function Get-LocalInstance {

    <#

    .SYNOPSIS
    Returns connection parameters for an available LocalDB instance.

    .DESCRIPTION
    Uses PsSqlLocalDb and the [SqlLocalDB utility](https://learn.microsoft.com/sql/tools/sqllocaldb-utility)
    to retrieve available LocalDB instances.

    .EXAMPLE
    PS> Get-SqlTestLocalInstance
    Gets the first available LocalDB instance. Requires PsSqlLocalDb and an installed LocalDB utility.
    Captured output (instance name redacted; the installed version may vary):

    Name             : <redacted>
    Version          : 15.0.4382.1
    DataSource       : (LocalDb)\<redacted>
    ConnectTimeout   : 30
    ConnectionString : Data Source=(LocalDb)\<redacted>;Connect Timeout=30;Integrated Security=True
    IsLocalDb        : True

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestLocalInstance.html

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

    $LocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.6.0 -PassThru
    if ( -not $LocalDbModule ) {
        return
    }

    $selectParam = @{}
    if ( $First ) {
        $selectParam.First = $First
    }

    Get-LocalDbInstance -Version:$Version | Select-Object @selectParam | ForEach-Object {
        $instance = $PSItem

        # add metadata
        $instance | Add-Member 'DataSource' "(LocalDb)\$( $instance.Name )"
        $instance | Add-Member 'ConnectTimeout' 30
        $instance | Add-Member 'ConnectionString' ( New-SqlConnectionString `
                -DataSource $instance.DataSource `
                -ConnectTimeout $instance.ConnectTimeout `
                -Authentication 'Integrated Security=True'
        )
        $instance | Add-Member 'IsLocalDb' $true

        # return
        $instance | Write-Output
    }
}
