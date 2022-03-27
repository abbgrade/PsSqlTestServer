function Remove-Instance {

    <#

    .SYNOPSIS
    Removes a test SQL server.

    .DESCRIPTION
    Removes a SQL server, in case it was created with `New-SqlTestInstance`.

    .EXAMPLE
    PS> $Instance = New-SqlTestInstance
    PS> Remove-SqlTestInstance -Server $Instance

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (
        # Specifies the server to remove.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        $Instance
    )

    if ( $Instance.IsDocker ) {
        $Instance | Remove-DockerInstance
    }

    if ( $Instance.IsLocalDb ) {
        $Instance | Remove-LocalInstance
    }
}
