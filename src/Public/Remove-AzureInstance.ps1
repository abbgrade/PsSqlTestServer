function Remove-AzureInstance {

    <#

    .SYNOPSIS
    Removes a test Azure SQL Server.

    .DESCRIPTION
    Removes an Azure SQL Server created by New-SqlTestAzureInstance. Requires Az modules and an authenticated Azure context.

    .EXAMPLE
    PS> Connect-AzAccount
    PS> $instance = New-SqlTestAzureInstance -Location 'westeurope'
    PS> $instance | Remove-SqlTestAzureInstance
    Removes the Azure SQL Server created for this example. The resource group remains.
    Illustrative output: server removal status depends on the Az module version.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureInstance.html

    #>

    [CmdletBinding(SupportsShouldProcess)]
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
        if ( $WhatIfPreference -or $PSCmdlet.ShouldProcess($ServerName, 'Remove Azure SQL Server') ) {
            Remove-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $ServerName -WhatIf:$WhatIfPreference -Confirm:$false
        }
    }
}
