function Test-Docker {

    <#

    .SYNOPSIS
    Tests if a Docker-based SQL Server can be created.

    .DESCRIPTION
    Checks whether psdocker is installed and the Docker service is running.

    .EXAMPLE
    PS> Test-SqlTestDocker
    Checks whether a Docker-backed SQL Server can be created.
    Illustrative output: $true when Docker is available and running and $false otherwise.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestDocker.html

    .OUTPUTS
    bool

    #>

    [CmdletBinding()]
    param ()

    $psDockerModule = Import-Module psdocker -MinimumVersion '1.9.0' -PassThru -ErrorAction SilentlyContinue

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
