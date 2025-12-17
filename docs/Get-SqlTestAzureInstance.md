---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Get-SqlTestAzureInstance

## SYNOPSIS
Returns connection parameter for a existing Azure SQL Server.

## SYNTAX

```
Get-SqlTestAzureInstance [[-Subscription] <String>] [[-ResourceGroupName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves Azure SQL Servers and returns a object with the properties DataSource and ConnectionString.

## EXAMPLES

### EXAMPLE 1
```
Get-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
