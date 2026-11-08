function Get-TestAzureInstanceParameter {
    <#
    .SYNOPSIS
    Gets the Azure instance parameters for integration tests.

    .DESCRIPTION
    Uses the configured test subscription and optional Azure location environment variable.

    .EXAMPLE
    Get-TestAzureInstanceParameter
    Returns the configured subscription and, when set, location in a hashtable.
    #>
    [CmdletBinding()]
    param()

    $parameters = @{ Subscription = Get-TestAzureSubscription }
    if ( $env:PSSQLTESTSERVER_AZURE_LOCATION ) {
        $parameters.Location = $env:PSSQLTESTSERVER_AZURE_LOCATION
        Write-Verbose "Using Azure location '$($parameters.Location)' from environment variable PSSQLTESTSERVER_AZURE_LOCATION."
    }

    return $parameters
}
