function Test-DockerSqlServer {
    if ( Import-Module PSDocker -PassThru -ErrorAction SilentlyContinue ) {
        if ( ( Get-DockerVersion -ErrorAction SilentlyContinue ).Server ) {
            return $true
        }
    }
    return $false
}
