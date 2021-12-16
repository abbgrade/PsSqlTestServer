
function New-DockerSqlServer {

    <#

    .SYNOPSIS
    Returns connection parameter for a SQL server in a new Docker container.

    .DESCRIPTION
    Creates a Docker container with a SQL server installed.
    Returns a object with the properties DataSource and ConnectionString.

    .EXAMPLE
    PS> New-DockerSqlServer -AcceptEula
    Name             : Sandbox
    Hostname         : localhost
    UserId           : sa
    ConnectionString : Server='localhost';Encrypt=False;User Id='sa';Password='pa$$w0rd'
    IsDocker         : True
    Id               : 693d5e79169c50af4ab5b10e1af9069a987ec8902033f3c55f325e12199a61c1
    Names            : {Sandbox}
    Image            : mcr.microsoft.com/mssql/server
    Command          : "/opt/mssql/bin/permissions_check.sh /opt/mssql/bin/sqlservr"
    LocalVolumes     : {0}
    Labels           : {com.microsoft.product=Microsoft SQL Server, com.microsoft.version=15.0.4153.1, vendor=Microsoft}
    Mounts           : {}
    Networks         : {bridge}
    Ports            : {0.0.0.0:1433->1433/tcp}
    CreatedAt        : 2021-12-01 00:00:00 +0100 CET
    RunningFor       : 2 seconds ago
    Status           : Up 1 second
    Size             : 0B (virtual 1.54GB)

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (

        # Specifies the name of the new Docker container.
        [Parameter( Mandatory )]
        [string] $DockerContainerName = ( ( New-Guid ).Substring(0, 8) ),

        # Specifies the password for the sa user.
        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [string] $ServerAdminPassword = 'Pa$$w0rd!',

        # Confirms your acceptance of the [End-User Licensing Agreement](https://go.microsoft.com/fwlink/?linkid=857698).
        [Parameter( Mandatory )]
        [switch] $AcceptEula
    )

    Import-Module PsDocker -MinimumVersion 1.5.0 -ErrorAction Stop

    if ( -not $AcceptEula ) {
        throw "Accept the Microsoft EULA with -AcceptEula"
    }

    $environment = @{
        'ACCEPT_EULA' = "Y"
    }

    switch ( ( Get-DockerVersion -ErrorAction Stop ).Server.Engine.OSArch ) {
        'linux/amd64' {
            $environment['MSSQL_SA_PASSWORD'] = $ServerAdminPassword

            # create container
            $container = New-DockerContainer `
                -Image 'mcr.microsoft.com/mssql/server' `
                -Name $DockerContainerName `
                -Environment $environment `
                -Ports @{
                1433 = 1433
            } -Detach

            $readyMessage = 'SQL Server is now ready for client connections'
            foreach ( $index in (1..30)) {
                $sqlServerLog = Invoke-DockerCommand -Name $container.Name -Command 'tail --lines=100 /var/opt/mssql/log/errorlog' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -StringOutput
                if ( $sqlServerLog -and $sqlServerLog.Contains($readyMessage) ) {
                    Write-Verbose $readyMessage
                    break
                }
                Start-Sleep -Seconds 1
            }
        }
        'windows/amd64' {
            $environment['sa_password'] = $ServerAdminPassword

            # create container
            $container = New-DockerContainer `
                -Image 'microsoft/mssql-server-windows-developer' `
                -Name $DockerContainerName `
                -Environment $environment `
                -Ports @{
                1433 = 1433
            } -Detach -ErrorAction Stop

            foreach ( $index in (1..30)) {
                $status = Invoke-DockerCommand -Name $container.Name -Command 'powershell -C "Get-Service -Name MSSQLSERVER" | Select -ExpandProperty Status' -StringOutput -ErrorAction 'SilentlyContinue'
                if ( $status -eq 'Running' ) {
                    break
                }
                Start-Sleep -Seconds 1
            }

        }
        default {
            throw "$_ not implemented"
        }
    }

    $container | Add-Member 'Hostname' 'localhost'
    $container | Add-Member 'UserId' 'sa'
    $container | Add-Member 'ConnectionString' "Server='$( $container.Hostname )';Encrypt=False;User Id='$( $container.UserId )';Password='$ServerAdminPassword'"
    $container | Add-Member 'IsDocker' $true

    # return
    $container | Write-Output
}
