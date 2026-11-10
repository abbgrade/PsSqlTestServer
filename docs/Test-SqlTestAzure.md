---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestAzure.html
schema: 2.0.0
---

# Test-SqlTestAzure

## SYNOPSIS
Tests if a Azure-based SQL Server can be created.

## SYNTAX

```
Test-SqlTestAzure [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Checks whether the required Az modules are installed and an Azure account is authenticated.
Writes the version of each required Az module to verbose output.

## EXAMPLES

### EXAMPLE 1
```
Test-SqlTestAzure -Verbose
Checks whether Azure-backed SQL Server operations can be used in the current session.
Illustrative output includes the installed module versions and $true when requirements are met; results depend on installed modules and authentication.
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestAzure.html](https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestAzure.html)

