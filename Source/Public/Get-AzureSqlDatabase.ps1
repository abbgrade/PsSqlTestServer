function Get-AzureSqlDatabase {

    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string] $Subscription
    )

    if ( $Subscription ) {
        Set-AzContext -Subscription $Subscription -ErrorAction Stop
    }

    $ResourceGroup = Get-AzResourceGroup -Name 'PsSqlTestServer' -ErrorAction SilentlyContinue
    if ( -not $ResourceGroup ) {
        $ResourceGroup = New-AzResourceGroup -Name 'PsSqlTestServer' -Location 'West Europe' -ErrorAction Stop
    }
    $Server = New-AzSqlServer -ErrorAction Stop `
        -ServerName ( New-Guid ) `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Location $ResourceGroup.Location `
        -EnableActiveDirectoryOnlyAuthentication -ExternalAdminName ( ( Get-AzContext ).Account )

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

    [PSCustomObject] @{
        ConnectionString = "Data Source=$( $Server.FullyQualifiedDomainName );InitialCatalog=$( $Database.DatabaseName );Integrated Security=True"
        DataSource       = $Server.FullyQualifiedDomainName
        InitialCatalog   = $Database.DatabaseName
    } | Write-Output
}
