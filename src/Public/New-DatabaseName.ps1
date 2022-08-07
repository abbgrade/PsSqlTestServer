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
        [string] $Prefix = 'name'
    )

    if ( $Prefix ) {
        Write-Output "$Prefix-$( ( [string](New-Guid) ).Substring(0, 8) )"
    } else {
        Write-Output ( [string](New-Guid) ).Substring(0, 8)
    }

}
