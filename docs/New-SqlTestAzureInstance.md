---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureInstance.html
schema: 2.0.0
---

# New-SqlTestAzureInstance

## SYNOPSIS
Creates an Azure SQL Server and returns its connection parameters.

## SYNTAX

```
New-SqlTestAzureInstance [[-Subscription] <String>] [[-FirewallRule] <String>] [[-Location] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a server in the PsSqlTestServer resource group and returns an object with connection metadata.
If no location is specified, the existing resource group's location is used.
A location is required when
the resource group does not exist.
Requires Az modules, an authenticated Azure context, and permission to
create Azure SQL resources.

## EXAMPLES

### EXAMPLE 1
```
Connect-AzAccount
PS> $instance = New-SqlTestAzureInstance -FirewallRule justme
Creates an Azure SQL Server in the existing PsSqlTestServer resource group, allowing connections only from your current
IPv4 address.
Captured output (temporary server name redacted):
```

ResourceGroupName        : PsSqlTestServer
ServerName               : \<redacted\>
FullyQualifiedDomainName : \<redacted\>.database.windows.net
DataSource               : \<redacted\>.database.windows.net
ConnectTimeout           : 30
ConnectionString         : Data Source=\<redacted\>.database.windows.net;Connect Timeout=30;Authentication=Active Directory Integrated
PS\> $instance | Remove-SqlTestAzureInstance
Removes the Azure SQL Server created by this example.
The resource group remains and is not removed by this command.

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

### -FirewallRule
Specify which firewall rule to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Specifies the Azure region for the server and, if necessary, the new resource group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureInstance.html)

