---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabaseName.html
schema: 2.0.0
---

# New-SqlTestDatabaseName

## SYNOPSIS
Generates a database name.

## SYNTAX

```
New-SqlTestDatabaseName [[-Prefix] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Generates a short random database name with an optional prefix.
The generated suffix is based on a GUID.

## EXAMPLES

### EXAMPLE 1
```
New-SqlTestDatabaseName -Prefix 'test-'
Generates a database name with the specified prefix.
Captured output (random suffix redacted): test-<redacted>
```

## PARAMETERS

### -Prefix
Prefix to the database name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Test-
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

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabaseName.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabaseName.html)

