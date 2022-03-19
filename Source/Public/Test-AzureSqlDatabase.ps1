function Test-AzureSqlDatabase {

    [CmdletBinding()]
    param()

    if (
        ( Import-Module Az.Accounts -PassThru ) -and
        ( Import-Module Az.Resources -PassThru ) -and
        ( Import-Module Az.Sql -PassThru )
    ) {

        if ( Get-AzContext ) {
            return $true
        }
    }

    return $false
}
