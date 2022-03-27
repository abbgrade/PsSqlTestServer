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
        [string] $Name

    )

    begin {
        Import-Module PsSqlLocalDb -ErrorAction Stop
    }

    process {
        Remove-LocalDbInstance -Name $Name
    }
}
