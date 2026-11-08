function Wait-WindowsDockerSqlServer {

    <#

    .SYNOPSIS
    Waits for SQL Server in a Windows Docker container to start.

    .DESCRIPTION
    Checks the SQL Server error log in the specified container until its ready message appears or the timeout expires.

    .EXAMPLE
    Wait-WindowsDockerSqlServer -Name 'sql-test' -Timeout 30
    Checks the container log for SQL Server readiness for up to 30 seconds. Requires that container to be running.
    The function produces no output.

    #>

    [CmdletBinding()]
    param (
        # Specifies the Docker container to check.
        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Specifies the maximum number of seconds to wait.
        [Parameter()]
        [int] $Timeout = 30
    )

    $readyMessage = 'SQL Server is now ready for client connections'
    foreach ( $index in (1..$Timeout)) {
        $sqlServerLog = Invoke-DockerCommand `
            -Name $Name `
            -Command 'tail --lines=100 /var/opt/mssql/log/errorlog' `
            -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -StringOutput

        if ( $sqlServerLog -and $sqlServerLog.Contains($readyMessage) ) {
            Write-Verbose $readyMessage
            break
        }
        Start-Sleep -Seconds 1
    }
}
