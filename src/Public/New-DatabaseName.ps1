function New-DatabaseName {

    <#

    .SYNOPSIS
    Generates a database name.

    .DESCRIPTION
    Generates a short random database name with an optional prefix. The generated suffix is based on a GUID.

    .EXAMPLE
    PS> New-SqlTestDatabaseName -Prefix 'test-'
    Generates a database name with the specified prefix.
    Captured output (random suffix redacted): test-<redacted>

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabaseName.html

    #>

    [CmdletBinding()]
    param (
        # Prefix to the database name.
        [Parameter()]
        [string] $Prefix = 'test-'
    )

    if ( $Prefix ) {
        Write-Output "$Prefix$( ( [string](New-Guid) ).Substring(0, 8) )"
    } else {
        Write-Output ( [string](New-Guid) ).Substring(0, 8)
    }

}
