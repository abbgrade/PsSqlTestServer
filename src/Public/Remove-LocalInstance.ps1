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

    [CmdletBinding()]
    param (

        # Specifies the name of the instance to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # Previews removal without removing the LocalDB instance.
        [Parameter()]
        [switch] $WhatIf

    )

    begin {
        $LocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.4 -PassThru
        if ( -not $LocalDbModule ) {
            return
        }
    }

    process {
        if ( $WhatIf.IsPresent ) {
            Write-Verbose "Remove $Name" -Verbose
        } else {
            Remove-LocalDbInstance -Name $Name
        }
    }
}
