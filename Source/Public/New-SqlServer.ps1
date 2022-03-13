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

    if ( Test-LocalDb ) {
        Get-LocalDb |
            Write-Output
    }
    elseif ( Test-DockerSqlServer )
    {
        New-DockerSqlServer -AcceptEula |
            Write-Output
    }
    else {
        Write-Error 'No SQL server provider like Docker or LocalDb is available.'
    }
}
