---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# New-SqlTestAzureDatabase

## SYNOPSIS
Creates a new Azure SQL Database and returns the connection parameters.

## SYNTAX

```
New-SqlTestAzureDatabase [-Server] <Object> [<CommonParameters>]
```

## DESCRIPTION
Uses a existing test azure sql instance and creates a database for (temporary) use.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
PS> New-SqlTestAzureDatabase -Instance $instance
```

## PARAMETERS

### -Server
Specifies the Azure SQL Server.
\[Microsoft.Azure.Commands.Sql.Server.Model.AzureSqlServerModel\]

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Instance

Required: True
Position: 1
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
