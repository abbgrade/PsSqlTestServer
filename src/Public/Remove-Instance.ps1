function Remove-Instance {

    <#

    .SYNOPSIS
    Removes a test SQL server.

    .DESCRIPTION
    Removes a SQL Server instance created by New-SqlTestInstance, using its provider-specific removal command.

    .EXAMPLE
    PS> $Instance = New-SqlTestInstance
    PS> $Instance | Remove-SqlTestInstance
    Removes the instance created by this example.
    Illustrative output: the instance is removed; output depends on the selected provider.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestInstance.html

    #>

    [CmdletBinding( SupportsShouldProcess, PositionalBinding=$false )]
    param (
        # Specifies the server to remove.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        $Instance
    )

    if ( $Instance.IsDocker ) {
        $Instance | Remove-DockerInstance -WhatIf:$WhatIfPreference
    }

    if ( $Instance.IsLocalDb ) {
        $Instance | Remove-LocalInstance -WhatIf:$WhatIfPreference
    }
}
