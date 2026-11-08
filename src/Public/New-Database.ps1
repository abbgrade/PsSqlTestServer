function New-Database {

    <#

    .SYNOPSIS
    Creates a new database and returns the connection parameters.

    .DESCRIPTION
    Creates a database for temporary use on an existing SQL Server instance. The returned object includes the
    instance connection for later database removal. Use -Connected to also open and return a database connection.

    .EXAMPLE
    PS> $instance = New-SqlTestInstance
    PS> $instanceConnection = $instance | Connect-TSqlInstance
    PS> $database = New-SqlTestDatabase -Instance $instance -InstanceConnection $instanceConnection
    Creates a temporary database on the SQL Server instance.
    Captured output (temporary database and instance names redacted):

    Name             : test-<redacted>
    Version          : 15.0.4382.1
    DataSource       : (LocalDb)\test-<redacted>
    ConnectTimeout   : 30
    InitialCatalog   : test-<redacted>
    ConnectionString : Data Source=(LocalDb)\test-<redacted>;Connect Timeout=30;Integrated Security=True;Initial Catalog=test-<redacted>

    PS> $database | Remove-SqlTestDatabase
    PS> Disconnect-TSqlInstance -Connection $instanceConnection
    PS> $instance | Remove-SqlTestInstance
    Removes the database, closes the instance connection, and removes the server instance.

    .LINK
    https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabase.html

    #>

    [CmdletBinding()]
    param (
        # Specifies the instance, to create the database in.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        [PsObject] $Instance,

        # Specifies an open SQL connection to the instance.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [Alias('Connection')]
        [Microsoft.Data.SqlClient.SqlConnection] $InstanceConnection,

        # Specifies the name of the database to create.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( New-DatabaseName ),

        # Specifies whether a SqlClient connection should be created.
        [Parameter()]
        [switch] $Connected
    )

    process {
        $Database = $Instance.PsObject.Copy()
        $Database | Add-Member InstanceName $Database.Name
        $Database.Name = $Name

        Invoke-TSqlCommand "CREATE DATABASE [$Name]" -Connection $InstanceConnection

        $Database | Add-Member InitialCatalog $Name
        $Database.ConnectionString = New-SqlConnectionString `
            -ConnectionString $Database.ConnectionString `
            -InitialCatalog $Database.InitialCatalog
        $Database | Add-Member InstanceConnection $InstanceConnection

        # connect instance if needed
        if ( $Connected.IsPresent ) {
            $DatabaseConnection = $Database | Connect-TSqlInstance
            if ( $DatabaseConnection | Test-TSqlConnection ) {
                $Database.Connection = $DatabaseConnection
            } else {
                Write-Error "Failed to connect database."
            }
        }

        Write-Output $Database
    }
}
