function New-AzureDatabase {

    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string] $Subscription
    )

    if ( $Subscription ) {
        $azureContext = Set-AzContext -Subscription $Subscription -ErrorAction Stop -PassThru
    }
    else {
        $azureContext = Get-AzContext
    }

    $ResourceGroup = Get-AzResourceGroup -Name 'PsSqlTestServer' -ErrorAction SilentlyContinue
    if ( -not $ResourceGroup ) {
        $ResourceGroup = New-AzResourceGroup -Name 'PsSqlTestServer' -Location 'West Europe' -ErrorAction Stop
    }
    $Server = New-AzSqlServer -ErrorAction Stop `
        -ServerName ( New-Guid ) `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Location $ResourceGroup.Location `
        -EnableActiveDirectoryOnlyAuthentication -ExternalAdminName ( $azureContext.Account )

    $myIp = ( Invoke-WebRequest ifconfig.me/ip ).Content.Trim()

    New-AzSqlServerFirewallRule `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -ServerName $Server.ServerName `
        -FirewallRuleName 'myIP' `
        -StartIpAddress $myIp -EndIpAddress $myIp

    $Database = New-AzSqlDatabase -ErrorAction Stop `
        -DatabaseName ( New-Guid ) `
        -ServerName $Server.ServerName `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Edition GeneralPurpose -Vcore 1 -ComputeGeneration Gen5 -ComputeModel Serverless

    $Database | Add-Member ConnectTimeout 30
    $Database | Add-Member ConnectionString "Data Source=$( $Server.FullyQualifiedDomainName );Connect Timeout=30;InitialCatalog=$( $Database.DatabaseName );Integrated Security=True"
    $Database | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Database | Add-Member InitialCatalog $Database.DatabaseName
    $Database | Write-Output
}
