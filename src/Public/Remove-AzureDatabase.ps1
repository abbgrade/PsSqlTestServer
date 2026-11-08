function Remove-AzureDatabase {

    <#

    .SYNOPSIS
    Removes a Azure SQL Database.

    .DESCRIPTION
    Removes an Azure SQL Database created by New-SqlTestAzureDatabase. If the database object has RemoveServer set,
    its associated Azure SQL Server is removed as well. Requires Az modules and an authenticated Azure context.

    .EXAMPLE
    PS> Connect-AzAccount
    PS> $instance = New-SqlTestAzureInstance -Location 'westeurope'
    PS> $database = New-SqlTestAzureDatabase -Instance $instance
    PS> $database | Remove-SqlTestAzureDatabase
    Removes the temporary Azure SQL database.
    PS> $instance | Remove-SqlTestAzureInstance
    Removes the Azure SQL Server created for this example. Its resource group remains. Output depends on the Az module version.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureDatabase.html

    #>

    [CmdletBinding(SupportsShouldProcess)]
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

        # Specifies whether the associated server should also be removed.
        [Parameter( ValueFromPipelineByPropertyName )]
        [switch] $RemoveServer
    )

    process {
        if ( -not $WhatIfPreference -and -not $PSCmdlet.ShouldProcess("$ServerName/$DatabaseName", 'Remove Azure SQL database') ) {
            return
        }

        Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName -WhatIf:$WhatIfPreference -Confirm:$false

        if ( $RemoveServer.IsPresent ) {
            Remove-AzureInstance -ResourceGroupName $ResourceGroupName -ServerName $ServerName -WhatIf:$WhatIfPreference -Confirm:$false
        }
    }
}
