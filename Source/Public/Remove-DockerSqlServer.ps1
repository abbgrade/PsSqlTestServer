
function Remove-DockerSqlServer {

    <#

    .SYNOPSIS
    Removes a test SQL server Docker container.

    .DESCRIPTION
    Removes a SQL server Docker container, in case it was created with `New-DockerSqlServer`.

    .EXAMPLE
    PS> $server = New-DockerSqlServer -DockerContainerName 'Sandbox' -ServerAdminPassword 'pa$$w0rd' -AcceptEula
    PS> Remove-DockerSqlServer -DockerContainerName $server.Name

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (

        # Specifies the server to remove. Requires the name of the Docker container.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateScript({ $_.Name })]
        $Server

    )

    Import-Module PsDocker -MinimumVersion 1.5.0 -ErrorAction Stop

    Remove-DockerContainer -Name $Server.Name -Force
}
