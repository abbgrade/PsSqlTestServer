function New-LocalInstance {

    [CmdletBinding()]
    param (
        # Specifies the name of the instance to create.
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name = "test-$(( [string](New-Guid) ).Substring(0, 8))"
    )

    Import-Module PsSqlLocalDb -ErrorAction Stop

    # create instance
    $instance = New-LocalDbInstance -Name $Name

    # add metadata
    $instance | Add-Member 'DataSource' "(LocalDb)\$( $instance.Name )"
    $instance | Add-Member 'ConnectTimeout' 30
    $instance | Add-Member 'ConnectionString' "Data Source=$( $instance.DataSource );Connect Timeout=$( $instance.ConnectTimeout );Integrated Security=True"
    $instance | Add-Member 'IsLocalDb' $true

    # return
    $instance | Write-Output
}
