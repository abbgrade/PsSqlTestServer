function New-Database {

    <#

    .SYNOPSIS
    Creates a new database and returns the connection parameters.

    .DESCRIPTION
    Uses a existing test instance and creates a database for (temporary) use.
    It keeps an open connection to the instance for later removal.

    .EXAMPLE
    PS> $Instance = New-SqlTestInstance
    PS> $InstanceConnection = $Instance | Connect-TSqlInstance
    PS> New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection

    ConnectionString   : Data Source=(LocalDb)\MSSQLLocalDB;Connect Timeout=30;Integrated Security=True;Initial Catalog=a48b028c
    DataSource         : (LocalDb)\MSSQLLocalDB
    ConnectTimeout     : 30
    Version            : v11.0
    InitialCatalog     : a48b028c
    InstanceConnection : Microsoft.Data.SqlClient.SqlConnection

    #>

    [CmdletBinding()]
    param (
        # Specifies the instance, to create the database in.
        [Parameter( Mandatory, ValueFromPipeline )]
        [ValidateNotNullOrEmpty()]
        [PsObject] $Instance,

        # Specifies a open sql connection to the instance.
        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [Alias('Connection')]
        [Microsoft.Data.SqlClient.SqlConnection] $InstanceConnection,

        # Specifies the name of the database to create.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = ( New-DatabaseName ),

        # Speficies if a SqlClient connection should be created.
        [Parameter()]
        [switch] $Connected
    )

    process {
        $Database = $Instance.PsObject.Copy()
        $Database | Add-Member InstanceName $Database.Name
        $Database.Name = $Name

        Invoke-TSqlCommand "CREATE DATABASE [$Name]" -Connection $InstanceConnection

        $Database | Add-Member InitialCatalog $Name
        $Database.ConnectionString += ";Initial Catalog=$( $Database.InitialCatalog )"
        $Database | Add-Member InstanceConnection $InstanceConnection

        # connect instance if needed
        if ( $Connected.IsPresent ) {
            $DatabaseConnection = $Database | Connect-TSqlInstance
            $Database.Connection = $DatabaseConnection
        }

        Write-Output $Database
    }
}
