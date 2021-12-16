
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

        # Specifies the name of the new Docker container.
        [Parameter( Mandatory )]
        [string] $DockerContainerName

    )

    Import-Module PsDocker -MinimumVersion 1.5.0 -ErrorAction Stop

    Remove-DockerContainer -Name $DockerContainerName -Force
}
