function Remove-AzureInstance {

    <#

    .SYNOPSIS
    Removes a test Azure SQL Server.

    .DESCRIPTION
    Removes a Azure SQL Server, in case it was created with `New-SqlTestAzureInstance`.

    .EXAMPLE
    PS> $instance = New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
    PS> $instance | Remove-SqlTestAzureInstance

    #>

    [CmdletBinding()]
    param(
        # Specifies the resource group containing the server.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ResourceGroupName,

        # Specifies the server to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ServerName
    )

    process {
        Remove-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $ServerName
    }
}
