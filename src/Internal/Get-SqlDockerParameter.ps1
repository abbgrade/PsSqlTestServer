function Get-SqlDockerParameter {

    [CmdletBinding()]
    param (
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
            throw "$_ not supported"
        }
    }

    [PSCustomObject]@{
        Image = $Image
        ServerAdminPasswordVariable = $ServerAdminPasswordVariable
        WaitCommand = $WaitCommand
    } | Write-Output

}
