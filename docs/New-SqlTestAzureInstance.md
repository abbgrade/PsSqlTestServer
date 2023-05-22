---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# New-SqlTestAzureInstance

## SYNOPSIS
Returns connection parameter for a new Azure SQL Server.

## SYNTAX

```
New-SqlTestAzureInstance [[-Subscription] <String>] [[-FirewallRule] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a Azure SQL Server and returns a object with the properties DataSource and ConnectionString.

## EXAMPLES

### EXAMPLE 1
```
New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
