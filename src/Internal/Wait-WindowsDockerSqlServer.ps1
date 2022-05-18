function Wait-WindowsDockerSqlServer {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

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
