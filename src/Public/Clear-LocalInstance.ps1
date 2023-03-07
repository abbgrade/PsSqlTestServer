function Clear-LocalInstance {

    <#

    .SYNOPSIS
    Remove all localdb test instances

    .DESCRIPTION
    Remove all instances created by New-LocalInstance. These are identified using the 'test-' prefix.

    .EXAMPLE
    PS> Clear-SqlTestLocalInstance
    #>

    [CmdletBinding()]
    param (
        [Parameter()]
        [switch] $WhatIf
    )

    Import-Module PsSqlLocalDb -MinimumVersion 0.4 -ErrorAction Stop

    Get-LocalInstance -First $null | Where-Object Name -Like test-* | Remove-LocalInstance -WhatIf:$WhatIf
}
