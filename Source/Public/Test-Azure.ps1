function Test-Azure {

    [CmdletBinding()]
    param()

    if ( -Not ( Import-Module Az.Accounts -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'Az.Accounts is not installed.'
        return $false
    }

    if ( -Not ( Import-Module Az.Resources -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'Az.Resources is not installed.'
        return $false
    }

    if ( -Not ( Import-Module Az.Sql -PassThru -ErrorAction SilentlyContinue )) {
        Write-Warning 'Az.Sql is not installed.'
        return $false
    }

    if ( -Not ( Get-AzContext )) {
        Write-Warning 'Az is not logged in. Run Connect-AzAccount.'
        return $false
    }

    return $true
}
