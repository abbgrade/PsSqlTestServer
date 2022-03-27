function New-LocalInstance {

    [CmdletBinding()]
    param ()

    Import-Module PsSqlLocalDb -ErrorAction Stop

    $instance = Get-LocalDbInstance

    [PSCustomObject] @{
        ConnectionString = "Data Source=(LocalDb)\$( $instance.Name );Connect Timeout=30;Integrated Security=True"
        DataSource       = "(LocalDb)\$( $instance.Name )"
        ConnectTimeout   = 30
        Version          = $instance.Version
    } | Write-Output

}
