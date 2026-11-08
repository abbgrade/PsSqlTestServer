function New-SqlConnectionString {

    <#

    .SYNOPSIS
    Creates or extends a SQL connection string.

    .DESCRIPTION
    Builds a connection string from connection properties, or appends an initial catalog to an existing
    connection string. Used internally by the module's SQL instance and database commands.

    .EXAMPLE
    New-SqlConnectionString -DataSource 'localhost' -InitialCatalog 'test-db'
    Returns a SQL connection string composed from the supplied properties.
    Illustrative output: Data Source=localhost;Connect Timeout=30;Initial Catalog=test-db

    #>

    [CmdletBinding(DefaultParameterSetName = 'Compose')]
    param (
        # Specifies the data source for a new connection string.
        [Parameter(Mandatory, ParameterSetName = 'Compose')]
        [ValidateNotNullOrEmpty()]
        [string] $DataSource,

        # Specifies an existing connection string to extend with a database catalog.
        [Parameter(Mandatory, ParameterSetName = 'AppendInitialCatalog')]
        [ValidateNotNullOrEmpty()]
        [string] $ConnectionString,

        # Specifies the timeout for a new connection string.
        [Parameter(ParameterSetName = 'Compose')]
        [int] $ConnectTimeout = 30,

        # Specifies the authentication setting for a new connection string.
        [Parameter(ParameterSetName = 'Compose')]
        [string] $Authentication,

        # Specifies the database catalog to include in a new or existing connection string.
        [Parameter(ParameterSetName = 'Compose')]
        [Parameter(Mandatory, ParameterSetName = 'AppendInitialCatalog')]
        [ValidateNotNullOrEmpty()]
        [string] $InitialCatalog
    )

    if ( $PSCmdlet.ParameterSetName -eq 'AppendInitialCatalog' ) {
        return "$ConnectionString;Initial Catalog=$InitialCatalog"
    }

    $connectionString = "Data Source=$DataSource;Connect Timeout=$ConnectTimeout"
    if ( $InitialCatalog ) {
        $connectionString += ";Initial Catalog=$InitialCatalog"
    }
    if ( $Authentication ) {
        $connectionString += ";$Authentication"
    }

    return $connectionString
}
