function Test-DockerSqlServer {

    <#

    .SYNOPSIS
    Tests if a Docker-based SQL Server can be created.

    .DESCRIPTION
    Checks if psdocker is installed, and if the Docker service is running.

    .EXAMPLE
    PS> Test-DockerSqlServer

    True

    .OUTPUTS
    bool

    #>

    [CmdletBinding()]
    param ()

    $psDockerModule = Import-Module psdocker -MinimumVersion 1.7.0 -PassThru -ErrorAction SilentlyContinue

    if ( $psDockerModule ) {
        Write-Verbose "psdocker $( $psDockerModule.Version ) is installed."

        $dockerVersion = Get-DockerVersion -ErrorAction SilentlyContinue
        Write-Verbose "docker client $( $dockerVersion.Client.Version ) is installed."

        if ( ( $dockerVersion ).Server ) {
            Write-Verbose "docker server $( $dockerVersion.Server.Engine.Version ) is running."
            return $true
        }
    }
    return $false
}
