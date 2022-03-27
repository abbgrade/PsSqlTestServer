function New-AzureDatabase {

    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string] $Subscription
    )

    if ( $Subscription ) {
        $azureContext = Set-AzContext -Subscription $Subscription -ErrorAction Stop
    }
    else {
        $azureContext = Get-AzContext
    }

    $Database = New-AzSqlDatabase -ErrorAction Stop `
        -DatabaseName ( New-Guid ) `
        -ServerName $Server.ServerName `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Edition GeneralPurpose -Vcore 1 -ComputeGeneration Gen5 -ComputeModel Serverless

    $Database | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Database | Add-Member InitialCatalog $Database.DatabaseName
    $Database | Add-Member ConnectTimeout 30
    $Database | Add-Member ConnectionString "Data Source=$( $Database.DataSource );Connect Timeout=$( $Database.ConnectTimeout );Initial Catalog=$( $Database.InitialCatalog );Authentication=Active Directory Integrated"
    $Database | Write-Output
}
