function Wait-LinuxDockerSqlServer {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

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
