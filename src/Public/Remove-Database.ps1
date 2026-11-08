function Remove-Database {

    <#

    .SYNOPSIS
    Removes a database.

    .DESCRIPTION
    Removes a database using the instance connection stored on a database object returned by New-SqlTestDatabase.

    .EXAMPLE
    PS> $instance = New-SqlTestInstance
    PS> $instanceConnection = $instance | Connect-TSqlInstance
    PS> $database = New-SqlTestDatabase -Instance $instance -InstanceConnection $instanceConnection
    PS> $database | Remove-SqlTestDatabase
    Removes the database created for this example.
    Illustrative output: the database is dropped; output depends on the SQL client module version.
    PS> Disconnect-TSqlInstance -Connection $instanceConnection
    PS> $instance | Remove-SqlTestInstance
    Closes the connection and removes the server instance. Provider availability varies by environment.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDatabase.html

    #>

    [CmdletBinding()]
    param (
        # Specifies the database name, or accepts the InitialCatalog property from the pipeline.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [Alias('InitialCatalog')]
        [string] $Name,

        # Specifies the open connection to the SQL Server instance.
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
