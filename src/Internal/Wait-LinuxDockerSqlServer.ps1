function Wait-LinuxDockerSqlServer {

    <#

    .SYNOPSIS
    Waits for SQL Server in a Linux Docker container to start.

    .DESCRIPTION
    Checks the SQL Server service status in the specified container until it is running or the timeout expires.

    .EXAMPLE
    Wait-LinuxDockerSqlServer -Name 'sql-test' -Timeout 30
    Checks the SQL Server service in the named container for up to 30 seconds. Requires that container to be running.
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

    foreach ( $index in (1..$Timeout)) {
        $status = Invoke-DockerCommand `
            -Name $Name `
            -Command 'powershell -C "Get-Service -Name MSSQLSERVER" | Select -ExpandProperty Status' `
            -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -StringOutput

        if ( $status -eq 'Running' ) {
            break
        }
        Start-Sleep -Seconds 1
    }
}
