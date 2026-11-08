---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDatabase.html
schema: 2.0.0
---

# Remove-SqlTestDatabase

## SYNOPSIS
Removes a database.

## SYNTAX

```
Remove-SqlTestDatabase [-Name] <String> [-InstanceConnection] <SqlConnection>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a database using the instance connection stored on a database object returned by New-SqlTestDatabase.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestInstance
PS> $instanceConnection = $instance | Connect-TSqlInstance
PS> $database = New-SqlTestDatabase -Instance $instance -InstanceConnection $instanceConnection
PS> $database | Remove-SqlTestDatabase
Removes the database created for this example.
Illustrative output: the database is dropped; output depends on the SQL client module version.
PS> Disconnect-TSqlInstance -Connection $instanceConnection
PS> $instance | Remove-SqlTestInstance
Closes the connection and removes the server instance. Provider availability varies by environment.
```

## PARAMETERS

### -Name
Specifies the database name, or accepts the InitialCatalog property from the pipeline.

```yaml
Type: String
Parameter Sets: (All)
Aliases: InitialCatalog

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InstanceConnection
Specifies the open connection to the SQL Server instance.

```yaml
Type: SqlConnection
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDatabase.html](https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDatabase.html)

