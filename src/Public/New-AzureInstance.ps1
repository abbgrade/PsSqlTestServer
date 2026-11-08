function New-AzureInstance {

    <#

    .SYNOPSIS
    Creates an Azure SQL Server and returns its connection parameters.

    .DESCRIPTION
    Creates a server in the PsSqlTestServer resource group and returns an object with connection metadata.
    If no location is specified, the existing resource group's location is used. A location is required when
    the resource group does not exist. Requires Az modules, an authenticated Azure context, and permission to
    create Azure SQL resources.

    .EXAMPLE
    PS> Connect-AzAccount
    PS> $instance = New-SqlTestAzureInstance -FirewallRule justme
    Creates an Azure SQL Server in the existing PsSqlTestServer resource group, allowing connections only from your current
    IPv4 address.
    Captured output (temporary server name redacted):

    ResourceGroupName        : PsSqlTestServer
    ServerName               : <redacted>
    FullyQualifiedDomainName : <redacted>.database.windows.net
    DataSource               : <redacted>.database.windows.net
    ConnectTimeout           : 30
    ConnectionString         : Data Source=<redacted>.database.windows.net;Connect Timeout=30;Authentication=Active Directory Integrated
    PS> $instance | Remove-SqlTestAzureInstance
    Removes the Azure SQL Server created by this example.
    The resource group remains and is not removed by this command.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureInstance.html

    #>

    [CmdletBinding(SupportsShouldProcess)]
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

    if ( -not $WhatIfPreference -and -not $PSCmdlet.ShouldProcess('Azure SQL Server in resource group PsSqlTestServer', 'Create') ) {
        return
    }

    if ( $Subscription ) {
        Write-Verbose "Selecting Azure subscription '$Subscription'."
        $azureContext = Set-AzContext -Subscription $Subscription
        if ( -not $azureContext ) {
            return
        }
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
            Write-Error -Message "Resource group 'PsSqlTestServer' does not exist. Specify -Location to create it."
            return
        }
        Write-Verbose "Creating resource group 'PsSqlTestServer' in location '$Location'."
        $ResourceGroup = New-AzResourceGroup -Name 'PsSqlTestServer' -Location $Location -WhatIf:$WhatIfPreference -Confirm:$false
        if ( -not $ResourceGroup ) {
            return
        }
    }
    Write-Verbose "Using resource group '$($ResourceGroup.ResourceGroupName)' in location '$($ResourceGroup.Location)'."

    if ( -not $Location ) {
        $Location = $ResourceGroup.Location
    }

    $serverName = New-Guid
    Write-Verbose "Creating Azure SQL Server '$serverName' in resource group '$($ResourceGroup.ResourceGroupName)', location '$Location'."
    $Server = New-AzSqlServer `
        -ServerName $serverName `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Location $Location `
        -EnableActiveDirectoryOnlyAuthentication -ExternalAdminName $adminName `
        -WhatIf:$WhatIfPreference -Confirm:$false

    if ( -not $Server ) {
        return
    }

    Write-Verbose "Azure SQL Server '$serverName' was created. Creating firewall rule '$FirewallRule'."

    switch ( $FirewallRule ) {
        justme {
            $myIp = ( Invoke-WebRequest -Uri 'https://ipv4.icanhazip.com' -ErrorAction Stop ).Content.Trim()

            New-AzSqlServerFirewallRule `
                -ResourceGroupName $ResourceGroup.ResourceGroupName `
                -ServerName $Server.ServerName `
                -FirewallRuleName $FirewallRule `
                -StartIpAddress $myIp -EndIpAddress $myIp -WhatIf:$WhatIfPreference -Confirm:$false | Out-Null
        }
        all {
            New-AzSqlServerFirewallRule `
                -ResourceGroupName $ResourceGroup.ResourceGroupName `
                -ServerName $Server.ServerName `
                -FirewallRuleName $FirewallRule `
                -StartIpAddress '0.0.0.0' -EndIpAddress '255.255.255.255' -WhatIf:$WhatIfPreference -Confirm:$false | Out-Null
        }
    }

    $Server | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Server | Add-Member ConnectTimeout 30
    $Server | Add-Member ConnectionString ( New-SqlConnectionString `
            -DataSource $Server.DataSource `
            -ConnectTimeout $Server.ConnectTimeout `
            -Authentication 'Authentication=Active Directory Integrated'
    )
    $Server | Write-Output
}
