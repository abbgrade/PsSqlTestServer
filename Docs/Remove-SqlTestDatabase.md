---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlTestDatabase

## SYNOPSIS
Removes a database.

## SYNTAX

```
Remove-SqlTestDatabase [-Name] <String> [-InstanceConnection] <SqlConnection> [<CommonParameters>]
```

## DESCRIPTION
Removes a database, created using \`New-SqlTestInstance\` command.

## EXAMPLES

### EXAMPLE 1
```
$Instance = New-SqlTestInstance
PS> $InstanceConnection = $Instance | Connect-TSqlInstance
PS> $Database = New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection
PS> $Database | Remove-SqlTestDatabase
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

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
{{ Fill InstanceConnection Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
