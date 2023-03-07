function Remove-LocalInstance {

    <#

    .SYNOPSIS
    Removes a test SQL server.

    .DESCRIPTION
    Removes a SQL server, in case it was created with `New-SqlTestLocalInstance`.

    .EXAMPLE
    PS> $Instance = New-SqlTestLocalInstance
    PS> Remove-SqlTestLocalInstance -Server $Instance

    #>

    [CmdletBinding()]
    param (

        # Specifies the name of the instance to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [switch] $WhatIf

    )

    begin {
        Import-Module PsSqlLocalDb -MinimumVersion 0.4 -ErrorAction Stop
    }

    process {
        if ( $WhatIf.IsPresent ) {
            Write-Verbose "Remove $Name" -Verbose
        } else {
            Remove-LocalDbInstance -Name $Name
        }
    }
}
