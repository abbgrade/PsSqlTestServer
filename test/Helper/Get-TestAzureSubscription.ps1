function Get-TestAzureSubscription {
    <#
    .SYNOPSIS
    Gets the Azure subscription configured for integration tests.

    .DESCRIPTION
    Uses the environment variable, then the local test settings file, then the default subscription.

    .EXAMPLE
    Get-TestAzureSubscription
    Returns the configured test subscription, for example My Azure subscription.
    #>
    [CmdletBinding()]
    param()

    if ( $env:PSSQLTESTSERVER_AZURE_SUBSCRIPTION ) {
        Write-Verbose "Using Azure subscription '$env:PSSQLTESTSERVER_AZURE_SUBSCRIPTION' from environment variable PSSQLTESTSERVER_AZURE_SUBSCRIPTION."
        return $env:PSSQLTESTSERVER_AZURE_SUBSCRIPTION
    }

    $testDirectory = Split-Path -Path $PSScriptRoot -Parent
    $settingsPath = Join-Path -Path (Split-Path -Path $testDirectory -Parent) -ChildPath '.PsSqlTestServer.settings.json'
    if ( Test-Path -Path $settingsPath ) {
        $settings = Get-Content -Path $settingsPath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        if ( $settings.AzureSubscription -isnot [string] -or [string]::IsNullOrWhiteSpace($settings.AzureSubscription) ) {
            Write-Error -Message "The Azure test settings file '$settingsPath' must contain a non-empty string AzureSubscription." -ErrorAction Stop
        }
        Write-Verbose "Using Azure subscription '$($settings.AzureSubscription)' from local test settings."
        return $settings.AzureSubscription
    }

    Write-Verbose "No Azure test subscription is configured. Using default Azure subscription 'Visual Studio'."
    return 'Visual Studio'
}
