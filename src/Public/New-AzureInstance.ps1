function New-AzureInstance {

    <#

    .SYNOPSIS
    Returns connection parameter for a new Azure SQL Server.

    .DESCRIPTION
    Creates a Azure SQL Server and returns a object with the properties DataSource and ConnectionString.

    .EXAMPLE
    PS> New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'

    #>

    [CmdletBinding()]
    param(
        # Specifies the Azure Subscription name.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Subscription,

        # Specify which firewall rule to create.
        [Parameter()]
        [ValidateSet('all', 'justme')]
        [string] $FirewallRule = 'all'
    )

    if ( $Subscription ) {
        $azureContext = Set-AzContext -Subscription $Subscription -ErrorAction Stop
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

    switch ( $FirewallRule ) {
        justme {
            $myIp = ( Invoke-WebRequest ifconfig.me/ip ).Content.Trim()

            New-AzSqlServerFirewallRule `
                -ResourceGroupName $ResourceGroup.ResourceGroupName `
                -ServerName $Server.ServerName `
                -FirewallRuleName $FirewallRule `
                -StartIpAddress $myIp -EndIpAddress $myIp | Out-Null
        }
        all {
            New-AzSqlServerFirewallRule `
                -ResourceGroupName $ResourceGroup.ResourceGroupName `
                -ServerName $Server.ServerName `
                -FirewallRuleName $FirewallRule `
                -StartIpAddress '0.0.0.0' -EndIpAddress '255.255.255.255' | Out-Null
        }
    }

    $Server | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Server | Add-Member ConnectTimeout 30
    $Server | Add-Member ConnectionString "Data Source=$( $Server.DataSource );Connect Timeout=$( $Server.ConnectTimeout );Authentication=Active Directory Integrated"
    $Server | Write-Output
}
