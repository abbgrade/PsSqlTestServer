function Remove-AzDatabase {

    [CmdletBinding()]
    param(
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ResourceGroupName,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ServerName,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $DatabaseName
    )

    Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName

    Remove-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $ServerName
}
