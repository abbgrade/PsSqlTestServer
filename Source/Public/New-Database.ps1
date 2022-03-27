function New-Database {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [PsObject] $Instance,

        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Data.SqlClient.SqlConnection] $InstanceConnection,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( [string](New-Guid) ).Substring(0, 8)
    )

    $Database = $Instance.PsObject.Copy()

    Invoke-TSqlCommand "CREATE DATABASE [$Name]" -Connection $InstanceConnection

    $Database | Add-Member InitialCatalog $Name
    $Database.ConnectionString += ";Initial Catalog=$( $Database.InitialCatalog )"
    $Database | Add-Member InstanceConnection $InstanceConnection

    Write-Output $Database
}
