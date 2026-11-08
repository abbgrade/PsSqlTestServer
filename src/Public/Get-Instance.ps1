function Get-Instance {

    <#

    .SYNOPSIS
    Returns connection parameter for a SQL server.

    .DESCRIPTION
    Checks whether LocalDB is available and returns its instance information. If unavailable, writes an error.

    .EXAMPLE
    PS> Get-SqlTestInstance
    Gets an available LocalDB instance. Requires PsSqlLocalDb and an installed LocalDB utility.
    Captured output (instance name and version vary by environment):

    Name             : <redacted>
    Version          : 15.0.4382.1
    DataSource       : (LocalDb)\<redacted>
    ConnectTimeout   : 30
    ConnectionString : Data Source=(LocalDb)\<redacted>;Connect Timeout=30;Integrated Security=True
    IsLocalDb        : True

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestInstance.html

    #>

    [CmdletBinding()]
    param ()

    if ( Test-LocalDb ) {
        Get-LocalInstance |
            Write-Output
    }
    else {
        Write-Error 'No SQL server provider like LocalDb is available.'
    }
}
