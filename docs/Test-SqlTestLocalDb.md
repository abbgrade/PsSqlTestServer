---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestLocalDb.html
schema: 2.0.0
---

# Test-SqlTestLocalDb

## SYNOPSIS
Tests if a localDb-based SQL Server can be created.

## SYNTAX

```
Test-SqlTestLocalDb [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Checks whether PsSqlLocalDb and the \[SqlLocalDB utility\](https://learn.microsoft.com/sql/tools/sqllocaldb-utility)
are available.

## EXAMPLES

### EXAMPLE 1
```
Test-SqlTestLocalDb
Checks whether LocalDB instances can be used on this computer.
Illustrative output: $true when the LocalDB utility is available and $false otherwise.
```

## PARAMETERS

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

### bool
## NOTES

## RELATED LINKS

[https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestLocalDb.html](https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestLocalDb.html)

