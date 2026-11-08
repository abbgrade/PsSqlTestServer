function Get-SqlDockerParameter {

    <#

    .SYNOPSIS
    Gets Docker image settings for a supported server architecture.

    .DESCRIPTION
    Selects the SQL Server container image, password environment variable, and readiness command
    for the supplied Docker server architecture.

    .EXAMPLE
    Get-SqlDockerParameter -OsArch 'linux/amd64'
    Returns the Docker settings used internally to start a Linux SQL Server container.
    Illustrative output: an object containing the Linux SQL Server image, password variable, and readiness command.

    #>

    [CmdletBinding()]
    param (
        # Specifies the Docker server architecture, such as linux/amd64.
        $OsArch
    )

    switch ( $osArch ) {
        'linux/amd64' {
            $Image = 'mcr.microsoft.com/mssql/server'
            $ServerAdminPasswordVariable = 'MSSQL_SA_PASSWORD'
            $WaitCommand = Get-Command 'Wait-LinuxDockerSqlServer'
        }
        'windows/amd64' {
            $Image = 'microsoft/mssql-server-windows-developer'
            $ServerAdminPasswordVariable = 'sa_password'
            $WaitCommand = Get-Command 'Wait-WindowsDockerSqlServer'
        }
        default {
            Write-Error "$_ not supported"
            return
        }
    }

    [PSCustomObject]@{
        Image = $Image
        ServerAdminPasswordVariable = $ServerAdminPasswordVariable
        WaitCommand = $WaitCommand
    } | Write-Output

}
