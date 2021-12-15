
function Remove-DockerSqlServer {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory )]
        [string] $DockerContainerName
    )

    Import-Module PsDocker -MinimumVersion 1.5.0 -ErrorAction Stop

    Remove-DockerContainer -Name $DockerContainerName -Force
}
