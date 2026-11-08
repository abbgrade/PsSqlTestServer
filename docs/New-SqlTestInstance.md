---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestInstance.html
schema: 2.0.0
---

# New-SqlTestInstance

## SYNOPSIS
Returns connection parameter for a SQL server.

## SYNTAX

```
New-SqlTestInstance [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Checks whether LocalDB is available and creates an instance using that provider.
If unavailable, it uses Docker.
Requires LocalDB or Docker and the corresponding module.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestInstance
Creates a temporary SQL Server instance using an available provider.
Captured output (temporary instance name redacted; LocalDB was selected on the example system):
```

Name             : test-\<redacted\>
Version          : 15.0.4382.1
DataSource       : (LocalDb)\test-\<redacted\>
ConnectTimeout   : 30
ConnectionString : Data Source=(LocalDb)\test-\<redacted\>;Connect Timeout=30;Integrated Security=True
IsLocalDb        : True
PS\> $instance | Remove-SqlTestInstance
Removes the instance created by this example.

## PARAMETERS

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

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestInstance.html)

