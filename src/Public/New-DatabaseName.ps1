function New-DatabaseName {

    <#

    .SYNOPSIS
    Generates a database name.

    .DESCRIPTION
    Generates a short random database name.

    #>

    [CmdletBinding()]
    param (
        # Prefix to the database name.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Prefix = 'name'
    )

    Write-Output "$Prefix-$( ( [string](New-Guid) ).Substring(0, 8) )"
}
