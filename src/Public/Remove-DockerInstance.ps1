
function Remove-DockerInstance {

    <#

    .SYNOPSIS
    Removes a test SQL server Docker container.

    .DESCRIPTION
    Removes a SQL Server Docker container created by New-SqlTestDockerInstance. Requires Docker and the psdocker module.

    .EXAMPLE
    PS> $container = New-SqlTestDockerInstance -DockerContainerName 'sql-test' -AcceptEula
    PS> $container | Remove-SqlTestDockerInstance
    Removes the container created by this example.
    Illustrative output: the container is removed; output depends on the psdocker version.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDockerInstance.html

    #>

    [CmdletBinding( SupportsShouldProcess, PositionalBinding=$false )]
    param (

        # Specifies the server to remove. Requires the name of the Docker container.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateScript({ $_.Name })]
        $Server

    )

    process {
        $DockerModule = Import-Module psdocker -MinimumVersion '1.10.0' -PassThru
        if ( -not $DockerModule ) {
            return
        }

        Remove-DockerContainer -Name $Server.Name -Force -WhatIf:$WhatIfPreference
    }
}
