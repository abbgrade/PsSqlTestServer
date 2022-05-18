function Remove-Database {

    <#

    .SYNOPSIS
    Removes a database.

    .DESCRIPTION
    Removes a database, created using `New-SqlTestInstance` command.

    .EXAMPLE
    PS> $Instance = New-SqlTestInstance
    PS> $InstanceConnection = $Instance | Connect-TSqlInstance
    PS> $Database = New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection
    PS> $Database | Remove-SqlTestDatabase

    #>

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
