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
        $subscriptionId = [guid]::Empty
        if ( [guid]::TryParse($Subscription, [ref]$subscriptionId) ) {
            $subscriptionDetails = Get-AzSubscription -SubscriptionId $subscriptionId -ErrorAction Stop
        }
        else {
            $subscriptionDetails = @(Get-AzSubscription -SubscriptionName $Subscription -ErrorAction Stop)
        }

        if ( -Not $subscriptionDetails ) {
            Write-Error -Message "Azure subscription '$Subscription' was not found or is not accessible to the current account." -ErrorAction Stop
        }
        if ( $subscriptionDetails.Count -gt 1 ) {
            Write-Error -Message "Multiple Azure subscriptions named '$Subscription' were found. Specify the subscription ID instead." -ErrorAction Stop
        }

        Write-Verbose "Setting Azure context to subscription '$($subscriptionDetails[0].Name)' ($($subscriptionDetails[0].Id))."
        $azureContext = Set-AzContext -Subscription $subscriptionDetails[0].Id -ErrorAction Stop
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
        Write-Error -Message "Azure resource group '$ResourceGroupName' was not found in the selected subscription. Create it with New-SqlTestAzureInstance or specify an existing one." -ErrorAction Stop
    }

    $Server = Get-AzSqlServer -ErrorAction Stop `
        -ResourceGroupName $ResourceGroup.ResourceGroupName

    $Server | Add-Member DataSource $Server.FullyQualifiedDomainName
    $Server | Add-Member ConnectTimeout 30
    $Server | Add-Member ConnectionString "Data Source=$( $Server.DataSource );Connect Timeout=$( $Server.ConnectTimeout );Authentication=Active Directory Integrated"
    $Server | Write-Output
}
