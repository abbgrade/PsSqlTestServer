---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestDocker.html
schema: 2.0.0
---

# Test-SqlTestDocker

## SYNOPSIS
Tests if a Docker-based SQL Server can be created.

## SYNTAX

```
Test-SqlTestDocker [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Checks whether psdocker is installed and the Docker service is running.

## EXAMPLES

### EXAMPLE 1
```
Test-SqlTestDocker
Checks whether a Docker-backed SQL Server can be created.
Illustrative output: $true when Docker is available and running and $false otherwise.
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestDocker.html](https://abbgrade.github.io/PsSqlTestServer/docs/Test-SqlTestDocker.html)

