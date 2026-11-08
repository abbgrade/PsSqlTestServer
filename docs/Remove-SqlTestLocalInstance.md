---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestLocalInstance.html
schema: 2.0.0
---

# Remove-SqlTestLocalInstance

## SYNOPSIS
Removes a test SQL server.

## SYNTAX

```
Remove-SqlTestLocalInstance [-Name] <String> [-WhatIf] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a LocalDB instance created by New-SqlTestLocalInstance.
Requires PsSqlLocalDb.

## EXAMPLES

### EXAMPLE 1
```
$Instance = New-SqlTestLocalInstance
PS> $Instance | Remove-SqlTestLocalInstance
Removes the LocalDB instance created by this example.
Illustrative output: the LocalDB instance is removed; output depends on the PsSqlLocalDb version.
```

## PARAMETERS

### -Name
Specifies the name of the instance to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Previews removal without removing the LocalDB instance.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestLocalInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestLocalInstance.html)

