function New-AzureDatabase {

    <#

    .SYNOPSIS
    Creates a new Azure SQL Database and returns the connection parameters.

    .DESCRIPTION
    Uses a existing test azure sql instance and creates a database for (temporary) use.

    .EXAMPLE
    PS> $instance = New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
    PS> New-SqlTestAzureDatabase -Instance $instance

    #>

    [CmdletBinding()]
    param(
        # Specifies the Azure SQL Server.
        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Instance' )]
        # [Microsoft.Azure.Commands.Sql.Server.Model.AzureSqlServerModel]
        $Server
    )

    $Database = New-AzSqlDatabase -ErrorAction Stop `
        -DatabaseName ( New-Guid ) `
        -ServerName $Server.ServerName `
        -ResourceGroupName $Server.ResourceGroupName `
        -Edition GeneralPurpose -Vcore 1 -ComputeGeneration Gen5 -ComputeModel Serverless

    $Database | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Database | Add-Member InitialCatalog $Database.DatabaseName
    $Database | Add-Member ConnectTimeout 30
    $Database | Add-Member ConnectionString "Data Source=$( $Database.DataSource );Connect Timeout=$( $Database.ConnectTimeout );Initial Catalog=$( $Database.InitialCatalog );Authentication=Active Directory Integrated"
    $Database | Write-Output
}
