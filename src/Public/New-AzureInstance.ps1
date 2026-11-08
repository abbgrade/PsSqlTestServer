function New-AzureInstance {

    <#

    .SYNOPSIS
    Returns connection parameter for a new Azure SQL Server.

    .DESCRIPTION
    Creates a Azure SQL Server and returns a object with the properties DataSource and ConnectionString.
    If no location is specified, the server uses the existing resource group's location.
    A location is required when the resource group does not exist.

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
        [string] $FirewallRule = 'all',

        # Specifies the Azure region for the server and, if necessary, the new resource group.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Location
    )

    if ( $Subscription ) {
        Write-Verbose "Selecting Azure subscription '$Subscription'."
        $azureContext = Set-AzContext -Subscription $Subscription -ErrorAction Stop
    }
    else {
        Write-Verbose 'Using the current Azure context.'
        $azureContext = Get-AzContext
    }

    Write-Verbose "Azure subscription: '$($azureContext.Subscription.Name)' ($($azureContext.Subscription.Id)); tenant: '$($azureContext.Tenant.Id)'."

    # Guest accounts are known in the directory by a UPN that differs from the account name.
    $adminName = $azureContext.Account.Id
    $signedInUser = Get-AzADUser -SignedIn -ErrorAction SilentlyContinue
    if ( $signedInUser.UserPrincipalName ) {
        $adminName = $signedInUser.UserPrincipalName
    }
    Write-Verbose "Using '$adminName' as Entra admin of the Azure SQL Server."

    Write-Verbose "Looking up resource group 'PsSqlTestServer'."
    $ResourceGroup = Get-AzResourceGroup -Name 'PsSqlTestServer' -ErrorAction SilentlyContinue
    if ( -not $ResourceGroup ) {
        if ( -not $Location ) {
            Write-Error -Message "Resource group 'PsSqlTestServer' does not exist. Specify -Location to create it." -ErrorAction Stop
        }
        Write-Verbose "Creating resource group 'PsSqlTestServer' in location '$Location'."
        $ResourceGroup = New-AzResourceGroup -Name 'PsSqlTestServer' -Location $Location -ErrorAction Stop
    }
    Write-Verbose "Using resource group '$($ResourceGroup.ResourceGroupName)' in location '$($ResourceGroup.Location)'."

    if ( -not $Location ) {
        $Location = $ResourceGroup.Location
    }

    $serverName = New-Guid
    Write-Verbose "Creating Azure SQL Server '$serverName' in resource group '$($ResourceGroup.ResourceGroupName)', location '$Location'."
    $Server = New-AzSqlServer -ErrorAction Stop `
        -ServerName $serverName `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Location $Location `
        -EnableActiveDirectoryOnlyAuthentication -ExternalAdminName $adminName

    Write-Verbose "Azure SQL Server '$serverName' was created. Creating firewall rule '$FirewallRule'."

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
