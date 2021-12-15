function Remove-SqlServer {

    [CmdletBinding()]
    param (
        $Server
    )

    if ( $Server.IsDocker ) {
        Remove-DockerSqlServer -DockerContainerName 'PsSqlTestServer'
    }
}
