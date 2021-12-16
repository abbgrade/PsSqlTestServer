function New-SqlServer {

    <#

    .SYNOPSIS
    Returns connection parameter for a SQL server.

    .DESCRIPTION
    Checks different versions of local db or creates a Docker container with a SQL server installed.
    Returns a object with the properties DataSource and ConnectionString.

    .EXAMPLE
    PS> New-SqlServer
    ConnectionString                                            DataSource
    ----------------                                            ----------
    Data Source=(LocalDb)\MSSQLLocalDB;Integrated Security=True (LocalDb)\MSSQLLocalDB

    #>

    [CmdletBinding()]
    param ()

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
        [string] $script:password = 'Pa$$w0rd!'
        [securestring] $script:securePassword = ConvertTo-SecureString $script:password -AsPlainText -Force

        New-DockerSqlServer -ServerAdminPassword $script:password -DockerContainerName 'PsSqlTestServer' -AcceptEula
    }
}
