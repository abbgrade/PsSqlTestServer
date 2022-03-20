function Remove-Instance {

    <#

    .SYNOPSIS
    Removes a test SQL server.

    .DESCRIPTION
    Removes a SQL server, in case it was created with `New-SqlTestInstance`.

    .EXAMPLE
    PS> $server = New-SqlTestInstance
    PS> Remove-SqlTestInstance -Server $server

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (
        # Specifies the server to remove.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        $Server
    )

    if ( $Server.IsDocker ) {
        $Server | Remove-DockerInstance
    }
}
