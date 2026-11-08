
function New-DockerInstance {

    <#

    .SYNOPSIS
    Returns connection parameter for a SQL server in a new Docker container.

    .DESCRIPTION
    Creates a Docker container with SQL Server and returns an object with connection metadata. Requires Docker,
    the psdocker module, and acceptance of the Microsoft SQL Server EULA.

    .EXAMPLE
    PS> $container = New-SqlTestDockerInstance -DockerContainerName 'sql-test' -Port 58955 -AcceptEula
    Creates a SQL Server container named sql-test. Container details and mapped port depend on the local Docker environment.
    Captured output (password omitted):

    Name                   : sql-test
    Hostname               : localhost
    DataSource             : localhost
    Port                   : 58955
    UserId                 : sa
    ConnectTimeout         : 30
    IsDocker               : True
    TrustServerCertificate : True

    PS> $container | Remove-SqlTestDockerInstance
    Removes the container created by this example.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDockerInstance.html

    #>

    [CmdletBinding( PositionalBinding=$false )]
    param (

        # Specifies the name of the new Docker container.
        [Parameter()]
        [string] $DockerContainerName = ( ( New-Guid ).ToString().Substring(0, 8) ),

        # Specifies the password for the sa user.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ServerAdminPassword = 'Pa$$w0rd!',

        # Confirms your acceptance of the [End-User Licensing Agreement](https://go.microsoft.com/fwlink/?linkid=857698).
        [Parameter( Mandatory )]
        [switch] $AcceptEula,

        # Specifies the seconds to wait for the SQL service.
        [Parameter()]
        [int] $Timeout = 30,

        # Specifies the port to map the sql server to.
        [Parameter()]
        [int] $Port = 1433
    )

    if ( -not $AcceptEula ) {
        Write-Error "Accept the Microsoft EULA with -AcceptEula"
        return
    }

    $DockerModule = Import-Module psdocker -MinimumVersion '1.10.0' -PassThru
    if ( -not $DockerModule ) {
        return
    }

    $dockerVersion = Get-DockerVersion
    if ( -not $dockerVersion ) {
        return
    }

    $osArch = $dockerVersion.Server.Engine.OSArch
    Write-Verbose "Create $osArch container."
    $dockerParameter = Get-SqlDockerParameter -OsArch $osArch
    if ( -not $dockerParameter ) {
        return
    }

    # create container
    $container = New-DockerContainer `
        -Image $dockerParameter.Image `
        -Name $DockerContainerName `
        -Environment @{
            'ACCEPT_EULA' = "Y"
            $dockerParameter.ServerAdminPasswordVariable = $ServerAdminPassword
        } `
        -Ports @{
            "$Port" = 1433
        } -Detach

    if ( -not $container ) {
        return
    }

    # await the service
    & $dockerParameter.WaitCommand -Name $container.Name -Timeout $Timeout -Verbose

    # add metadata
    $container | Add-Member 'Hostname' 'localhost'
    $container | Add-Member 'DataSource' 'localhost'
    $container | Add-Member 'Port' $Port
    $container | Add-Member 'UserId' 'sa'
    $container | Add-Member 'SecurePassword' (
        ConvertTo-SecureString $ServerAdminPassword -AsPlainText -Force
    )
    $container | Add-Member 'ConnectTimeout' 30
    $container | Add-Member 'ConnectionString' "Server='$( $container.Hostname ),$( $container.Port )';Connect Timeout=$( $container.ConnectTimeout );TrustServerCertificate=True;User Id='$( $container.UserId )';Password='$ServerAdminPassword'"
    $container | Add-Member 'IsDocker' $true
    $container | Add-Member 'DatabaseCredential' (
        New-Object System.Management.Automation.PSCredential ($container.UserId, $container.SecurePassword)
    )
    $container | Add-Member 'TrustServerCertificate' $true

    # return
    $container | Write-Output
}
