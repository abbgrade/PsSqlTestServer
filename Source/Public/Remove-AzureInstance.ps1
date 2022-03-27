function Remove-AzureInstance {

    [CmdletBinding()]
    param(
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ResourceGroupName,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ServerName
    )

    process {
        Remove-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $ServerName
    }
}
