function New-AzureDatabase {

    <#

    .SYNOPSIS
    Creates a new Azure SQL Database and returns the connection parameters.

    .DESCRIPTION
    Creates a database for temporary use on an existing Azure SQL Server. Requires Az modules and an authenticated
    Azure context. When creating a server with -Subscription, the returned database has a RemoveServer property
    that allows Remove-SqlTestAzureDatabase to remove the server as well.

    .EXAMPLE
    PS> Connect-AzAccount
    PS> $instance = New-SqlTestAzureInstance -FirewallRule justme
    PS> $database = New-SqlTestAzureDatabase -Server $instance
    Creates a temporary database on the specified Azure SQL Server.
    Captured output (temporary server and database names redacted):

    DatabaseName     : <redacted>
    DataSource       : <redacted>.database.windows.net
    InitialCatalog   : <redacted>
    ConnectTimeout   : 30
    ConnectionString : Data Source=<redacted>.database.windows.net;Connect Timeout=30;Initial Catalog=<redacted>
    PS> $database | Remove-SqlTestAzureDatabase
    PS> $instance | Remove-SqlTestAzureInstance
    Removes the database and the server created for this example.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureDatabase.html

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Specifies the Azure SQL Server.
        [Parameter( Mandatory, ParameterSetName='UseServer' )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Instance' )]
        # [Microsoft.Azure.Commands.Sql.Server.Model.AzureSqlServerModel]
        $Server,

        # Specifies the Azure Subscription name.
        [Parameter( Mandatory, ParameterSetName='NewServer' )]
        [ValidateNotNullOrEmpty()]
        [string] $Subscription
    )

    switch ( $PSCmdlet.ParameterSetName ) {
        NewServer {
            $Server = New-AzureInstance -Subscription:$Subscription -WhatIf:$WhatIfPreference
            if ( -not $Server ) {
                return
            }
        }
    }

    if ( -not $WhatIfPreference -and -not $PSCmdlet.ShouldProcess($Server.ServerName, 'Create Azure SQL database') ) {
        return
    }

    $Database = New-AzSqlDatabase `
        -DatabaseName ( New-Guid ) `
        -ServerName $Server.ServerName `
        -ResourceGroupName $Server.ResourceGroupName `
        -Edition GeneralPurpose -Vcore 1 -ComputeGeneration Gen5 -ComputeModel Serverless `
        -WhatIf:$WhatIfPreference -Confirm:$false

    if ( -not $Database ) {
        return
    }

    $Database | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Database | Add-Member InitialCatalog $Database.DatabaseName
    $Database | Add-Member ConnectTimeout 30
    $Database | Add-Member ConnectionString ( New-SqlConnectionString `
            -DataSource $Database.DataSource `
            -ConnectTimeout $Database.ConnectTimeout `
            -InitialCatalog $Database.InitialCatalog
    )

    switch ( $PSCmdlet.ParameterSetName ) {
        NewServer {
            $Database | Add-Member RemoveServer $true
        }
    }

    $Database | Write-Output
}
