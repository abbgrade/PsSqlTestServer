---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlTestAzureDatabase

## SYNOPSIS
Removes a Azure SQL Database.

## SYNTAX

```
Remove-SqlTestAzureDatabase [-ResourceGroupName] <Object> [-ServerName] <Object> [-DatabaseName] <Object>
 [<CommonParameters>]
```

## DESCRIPTION
Removes a Azure SQL Database, created using \`New-SqlTestAzureInstance\` command.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestAzureInstance -Subscription 'MyAzureSubscription'
PS> $database = New-SqlTestAzureDatabase -Instance $instance
PS> $database | Remove-SqlTestAzureDatabase
PS> $instance | Remove-SqlTestAzureInstance
```

## PARAMETERS

### -ResourceGroupName
Specifies the resource group containing the database.

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
Specifies the server to remove the database from.

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

### -DatabaseName
Specifies the database to remove.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
