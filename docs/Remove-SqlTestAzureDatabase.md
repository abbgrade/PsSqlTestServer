---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureDatabase.html
schema: 2.0.0
---

# Remove-SqlTestAzureDatabase

## SYNOPSIS
Removes a Azure SQL Database.

## SYNTAX

```
Remove-SqlTestAzureDatabase [-ResourceGroupName] <Object> [-ServerName] <Object> [-DatabaseName] <Object>
 [-RemoveServer] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Removes an Azure SQL Database created by New-SqlTestAzureDatabase.
If the database object has RemoveServer set,
its associated Azure SQL Server is removed as well.
Requires Az modules and an authenticated Azure context.

## EXAMPLES

### EXAMPLE 1
```
Connect-AzAccount
PS> $instance = New-SqlTestAzureInstance -Location 'westeurope'
PS> $database = New-SqlTestAzureDatabase -Instance $instance
PS> $database | Remove-SqlTestAzureDatabase
Removes the temporary Azure SQL database.
PS> $instance | Remove-SqlTestAzureInstance
Removes the Azure SQL Server created for this example. Its resource group remains. Output depends on the Az module version.
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

### -RemoveServer
Specifies whether the associated server should also be removed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureDatabase.html](https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureDatabase.html)

