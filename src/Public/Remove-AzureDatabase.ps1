function Remove-AzureDatabase {

    <#

    .SYNOPSIS
    Removes a Azure SQL Database.

    .DESCRIPTION
    Removes a Azure SQL Database, created using `New-SqlTestAzureInstance` command.

    .EXAMPLE
    PS> $instance = New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
    PS> $database = New-SqlTestAzureDatabase -Instance $instance
    PS> $database | Remove-SqlTestAzureDatabase
    PS> $instance | Remove-SqlTestAzureInstance

    #>

    [CmdletBinding()]
    param(
        # Specifies the resource group containing the database.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ResourceGroupName,

        # Specifies the server to remove the database from.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $ServerName,

        # Specifies the database to remove.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        $DatabaseName,

        # Specifies if the server should be removed as well.
        [Parameter( ValueFromPipelineByPropertyName )]
        [switch] $RemoveServer
    )

    process {
        Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName

        if ( $RemoveServer.IsPresent ) {
            Remove-AzureInstance -ResourceGroupName $ResourceGroupName -ServerName $ServerName
        }
    }
}
