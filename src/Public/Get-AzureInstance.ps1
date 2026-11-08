function Get-AzureInstance {

    <#

    .SYNOPSIS
    Returns connection parameters for an existing Azure SQL Server.

    .DESCRIPTION
    Retrieves Azure SQL Servers in the selected subscription and resource group and returns the first server
    with DataSource, ConnectTimeout, and ConnectionString properties. Requires Az modules and an authenticated
    Azure context.

    .EXAMPLE
    PS> Connect-AzAccount
    PS> Get-SqlTestAzureInstance
    Retrieves the first SQL Server from the default PsSqlTestServer resource group in the current subscription.
    Captured output (server name redacted):

    ResourceGroupName        : PsSqlTestServer
    ServerName               : <redacted>
    FullyQualifiedDomainName : <redacted>.database.windows.net
    DataSource               : <redacted>.database.windows.net
    ConnectTimeout           : 30
    ConnectionString         : Data Source=<redacted>.database.windows.net;Connect Timeout=30;Authentication=Active Directory Integrated

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestAzureInstance.html

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
        $subscriptionId = [guid]::Empty
        if ( [guid]::TryParse($Subscription, [ref]$subscriptionId) ) {
            $subscriptionDetails = Get-AzSubscription -SubscriptionId $subscriptionId
        }
        else {
            $subscriptionDetails = Get-AzSubscription -SubscriptionName $Subscription
        }

        if ( -Not $subscriptionDetails ) {
            Write-Error -Message "Azure subscription '$Subscription' was not found or is not accessible to the current account."
            return
        }
        if ( $subscriptionDetails.Count -gt 1 ) {
            Write-Error -Message "Multiple Azure subscriptions named '$Subscription' were found. Specify the subscription ID instead."
            return
        }

        Write-Verbose "Setting Azure context to subscription '$($subscriptionDetails[0].Name)' ($($subscriptionDetails[0].Id))."
        $azureContext = Set-AzContext -Subscription $subscriptionDetails[0].Id
    }
    else {
        Write-Verbose 'Using the current Azure context.'
        $azureContext = Get-AzContext
    }

    if ( $azureContext.Subscription ) {
        Write-Verbose "Using Azure subscription '$($azureContext.Subscription.Name)' ($($azureContext.Subscription.Id))."
    }

    Write-Verbose "Looking up Azure resource group '$ResourceGroupName'."
    $ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if ( $ResourceGroup ) {
        Write-Verbose "Using Azure resource group '$($ResourceGroup.ResourceGroupName)'."
    }
    else {
        Write-Error -Message "Azure resource group '$ResourceGroupName' was not found in the selected subscription. Create it with New-SqlTestAzureInstance or specify an existing one."
        return
    }

    $Servers = Get-AzSqlServer -ResourceGroupName $ResourceGroup.ResourceGroupName

    if ( -Not $Servers ) {
        Write-Error -Message "No Azure SQL Servers were found in resource group '$ResourceGroupName'."
        return
    }
    if ( $Servers.Count -gt 1 ) {
        Write-Warning "Multiple Azure SQL Servers were found in resource group '$ResourceGroupName'. Returning the first one."
    }

    $Server = $Servers[0]
    $Server | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Server | Add-Member ConnectTimeout 30
    $Server | Add-Member ConnectionString ( New-SqlConnectionString `
            -DataSource $Server.DataSource `
            -ConnectTimeout $Server.ConnectTimeout `
            -Authentication 'Authentication=Active Directory Integrated'
    )
    $Server | Write-Output
}
