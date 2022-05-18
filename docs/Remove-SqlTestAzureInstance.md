---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlTestAzureInstance

## SYNOPSIS
Removes a test Azure SQL Server.

## SYNTAX

```
Remove-SqlTestAzureInstance [-ResourceGroupName] <Object> [-ServerName] <Object> [<CommonParameters>]
```

## DESCRIPTION
Removes a Azure SQL Server, in case it was created with \`New-SqlTestAzureInstance\`.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
PS> $instance | Remove-SqlTestAzureInstance
```

## PARAMETERS

### -ResourceGroupName
Specifies the resource group containing the server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServerName
Specifies the server to remove.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
