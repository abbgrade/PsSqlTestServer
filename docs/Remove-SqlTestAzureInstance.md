---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureInstance.html
schema: 2.0.0
---

# Remove-SqlTestAzureInstance

## SYNOPSIS
Removes a test Azure SQL Server.

## SYNTAX

```
Remove-SqlTestAzureInstance [-ResourceGroupName] <Object> [-ServerName] <Object>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an Azure SQL Server created by New-SqlTestAzureInstance.
Requires Az modules and an authenticated Azure context.

## EXAMPLES

### EXAMPLE 1
```
Connect-AzAccount
PS> $instance = New-SqlTestAzureInstance -Location 'westeurope'
PS> $instance | Remove-SqlTestAzureInstance
Removes the Azure SQL Server created for this example. The resource group remains.
Illustrative output: server removal status depends on the Az module version.
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestAzureInstance.html)

