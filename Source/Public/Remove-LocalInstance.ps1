function Remove-LocalInstance {

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
