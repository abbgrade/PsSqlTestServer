
function Remove-DockerInstance {

    <#

    .SYNOPSIS
    Removes a test SQL server Docker container.

    .DESCRIPTION
    Removes a SQL server Docker container, in case it was created with `New-DockerSqlServer`.

    .EXAMPLE
    PS> $server = New-SqlTestDockerInstance -DockerContainerName 'Sandbox' -ServerAdminPassword 'pa$$w0rd' -AcceptEula
    PS> Remove-SqlTestDockerInstance -DockerContainerName $server.Name

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (

        # Specifies the server to remove. Requires the name of the Docker container.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateScript({ $_.Name })]
        $Server

    )

    begin {
        Import-Module psdocker -MinimumVersion 1.7.0 -ErrorAction Stop
    }

    process {
        Remove-DockerContainer -Name $Server.Name -Force
    }
}
