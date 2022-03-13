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

    if ( Import-Module psdocker -PassThru -ErrorAction SilentlyContinue ) {
        if ( ( Get-DockerVersion -ErrorAction SilentlyContinue ).Server ) {
            return $true
        }
    }
    return $false
}
