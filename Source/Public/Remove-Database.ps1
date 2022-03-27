function Remove-Database {

    [CmdletBinding()]
    param (
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [Alias('InitialCatalog')]
        [string] $Name,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Data.SqlClient.SqlConnection] $InstanceConnection
    )

    process {
        Invoke-TSqlCommand 'USE [master];' -Connection $InstanceConnection
        Invoke-TSqlCommand "ALTER DATABASE [$Name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE" -Connection $InstanceConnection
        Invoke-TSqlCommand "DROP DATABASE [$Name]" -Connection $InstanceConnection
    }
}
