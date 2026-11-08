function Clear-LocalInstance {

    <#

    .SYNOPSIS
    Removes all LocalDB test instances created by this module.

    .DESCRIPTION
    Removes instances created by New-SqlTestLocalInstance. These are identified using the 'test-' prefix.
    Requires PsSqlLocalDb.

    .EXAMPLE
    PS> Clear-SqlTestLocalInstance -WhatIf
    Previews removal of all matching LocalDB test instances without removing them.
    Illustrative output: no instances are removed; verbose output depends on the matching instances.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Clear-SqlTestLocalInstance.html
    #>

    [CmdletBinding()]
    param (
        # Previews removal without removing matching instances.
        [Parameter()]
        [switch] $WhatIf
    )

    $LocalDbModule = Import-Module PsSqlLocalDb -MinimumVersion 0.4 -PassThru
    if ( -not $LocalDbModule ) {
        return
    }

    Get-LocalInstance -First $null | Where-Object Name -Like test-* | Remove-LocalInstance -WhatIf:$WhatIf
}
