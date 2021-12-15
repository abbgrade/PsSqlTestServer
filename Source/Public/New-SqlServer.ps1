function New-SqlServer {

    [CmdletBinding()]
    param (
    )

    Invoke-Command {
        & sqllocaldb info
    } -ErrorVariable localDbError -ErrorAction 'SilentlyContinue' | Out-Null

    if ( -not $localDbError ) {
        $localBbInfo = & sqllocaldb info

        $server = @{
            DataSource = '(LocalDb)\MSSQLLocalDB'
        }
        $server.ConnectionString = "Data Source=$( $server.DataSource );Integrated Security=True"

        [PSCustomObject] $server
    }
    else
    {
        [string] $script:password = 'Passw0rd!'
        [securestring] $script:securePassword = ConvertTo-SecureString $script:password -AsPlainText -Force

        New-DockerSqlServer -ServerAdminPassword $script:password -DockerContainerName 'PsSqlTestServer' -AcceptEula
    }
}
