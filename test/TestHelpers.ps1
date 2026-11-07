function Get-TestAzureSubscription {
    if ( $env:PSSQLTESTSERVER_AZURE_SUBSCRIPTION ) {
        return $env:PSSQLTESTSERVER_AZURE_SUBSCRIPTION
    }

    return 'Visual Studio'
}
