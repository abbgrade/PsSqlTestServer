function Get-AzureInstance {

    <#

    .SYNOPSIS
    Returns connection parameter for a existing Azure SQL Server.

    .DESCRIPTION
    Retrieves Azure SQL Servers and returns a object with the properties DataSource and ConnectionString.

    .EXAMPLE
    PS> Get-SqlTestAzureInstance -Subscription 'MyAzureSubscription'

    #>

    [CmdletBinding()]
    param(
        # Specifies the Azure Subscription name.
        [ValidateNotNullOrEmpty()]
        [string] $Subscription,

        # Specifies the Azure Resource Group name.
        [ValidateNotNullOrEmpty()]
        [string] $ResourceGroupName = 'PsSqlTestServer'
    )

    if ( $Subscription ) {
        $azureContext = Set-AzContext -Subscription $Subscription -ErrorAction Stop
    }
    else {
        $azureContext = Get-AzContext
    }

    $ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

    $Server = Get-AzSqlServer -ErrorAction Stop `
        -ResourceGroupName $ResourceGroup.ResourceGroupName

    $Server | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Server | Add-Member ConnectTimeout 30
    $Server | Add-Member ConnectionString "Data Source=$( $Server.DataSource );Connect Timeout=$( $Server.ConnectTimeout );Authentication=Active Directory Integrated"
    $Server | Write-Output
}
