---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Clear-SqlTestLocalInstance.html
schema: 2.0.0
---

# Clear-SqlTestLocalInstance

## SYNOPSIS
Removes all LocalDB test instances created by this module.

## SYNTAX

```
Clear-SqlTestLocalInstance [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes instances created by New-SqlTestLocalInstance.
These are identified using the 'test-' prefix.
Requires PsSqlLocalDb.

## EXAMPLES

### EXAMPLE 1
```
Clear-SqlTestLocalInstance -WhatIf
Previews removal of all matching LocalDB test instances without removing them.
Illustrative output: no instances are removed; verbose output depends on the matching instances.
```

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

[https://abbgrade.github.io/PsSqlTestServer/docs/Clear-SqlTestLocalInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Clear-SqlTestLocalInstance.html)

