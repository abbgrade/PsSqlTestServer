---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestAzureInstance.html
schema: 2.0.0
---

# Get-SqlTestAzureInstance

## SYNOPSIS
Returns connection parameters for an existing Azure SQL Server.

## SYNTAX

```
Get-SqlTestAzureInstance [[-Subscription] <String>] [[-ResourceGroupName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Azure SQL Servers in the selected subscription and resource group and returns the first server
with DataSource, ConnectTimeout, and ConnectionString properties.
Requires Az modules and an authenticated
Azure context.

## EXAMPLES

### EXAMPLE 1
```
Connect-AzAccount
PS> Get-SqlTestAzureInstance
Retrieves the first SQL Server from the default PsSqlTestServer resource group in the current subscription.
Captured output (server name redacted):
```

ResourceGroupName        : PsSqlTestServer
ServerName               : \<redacted\>
FullyQualifiedDomainName : \<redacted\>.database.windows.net
DataSource               : \<redacted\>.database.windows.net
ConnectTimeout           : 30
ConnectionString         : Data Source=\<redacted\>.database.windows.net;Connect Timeout=30;Authentication=Active Directory Integrated

## PARAMETERS

### -Subscription
Specifies the Azure Subscription name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Specifies the Azure Resource Group name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: PsSqlTestServer
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestAzureInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestAzureInstance.html)

