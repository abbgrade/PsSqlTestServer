function Remove-LocalInstance {

    <#

    .SYNOPSIS
    Removes a test SQL server.

    .DESCRIPTION
    Removes a LocalDB instance created by New-SqlTestLocalInstance. Requires PsSqlLocalDb.

    .EXAMPLE
    PS> $Instance = New-SqlTestLocalInstance
    PS> $Instance | Remove-SqlTestLocalInstance
    Removes the LocalDB instance created by this example.
    Illustrative output: the LocalDB instance is removed; output depends on the PsSqlLocalDb version.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestLocalInstance.html

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (

        # Specifies the name of the instance to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name

    )

    process {
        $LocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.6.0 -PassThru
        if ( -not $LocalDbModule ) {
            return
        }

        Remove-LocalDbInstance -Name $Name -WhatIf:$WhatIfPreference
    }
}
