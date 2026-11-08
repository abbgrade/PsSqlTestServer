function New-Instance {

    <#

    .SYNOPSIS
    Returns connection parameter for a SQL server.

    .DESCRIPTION
    Checks whether LocalDB is available and creates an instance using that provider. If unavailable, it uses Docker.
    Requires LocalDB or Docker and the corresponding module.

    .EXAMPLE
    PS> $instance = New-SqlTestInstance
    Creates a temporary SQL Server instance using an available provider.
    Captured output (temporary instance name redacted; LocalDB was selected on the example system):

    Name             : test-<redacted>
    Version          : 15.0.4382.1
    DataSource       : (LocalDb)\test-<redacted>
    ConnectTimeout   : 30
    ConnectionString : Data Source=(LocalDb)\test-<redacted>;Connect Timeout=30;Integrated Security=True
    IsLocalDb        : True
    PS> $instance | Remove-SqlTestInstance
    Removes the instance created by this example.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestInstance.html

    #>

    [CmdletBinding()]
    param ()

    if ( Test-LocalDb ) {
        New-LocalInstance |
            Write-Output
    }
    elseif ( Test-Docker ) {
        New-DockerInstance -AcceptEula |
            Write-Output
    }
    else {
        Write-Error 'No SQL server provider like Docker or LocalDb is available.'
    }
}
