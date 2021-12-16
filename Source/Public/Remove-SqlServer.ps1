function Remove-SqlServer {

    <#

    .SYNOPSIS
    Removes a test SQL server.

    .DESCRIPTION
    Removes a SQL server, in case it was created with `New-SqlServer`.

    .EXAMPLE
    PS> $server = New-SqlServer
    PS> Remove-SqlServer -Server $server

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (
        # Specifies the server to remove.
        $Server
    )

    if ( $Server.IsDocker ) {
        Remove-DockerSqlServer -DockerContainerName 'PsSqlTestServer'
    }
}
