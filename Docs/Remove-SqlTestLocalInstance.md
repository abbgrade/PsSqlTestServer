---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlTestLocalInstance

## SYNOPSIS
Removes a test SQL server.

## SYNTAX

```
Remove-SqlTestLocalInstance [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Removes a SQL server, in case it was created with \`New-SqlTestLocalInstance\`.

## EXAMPLES

### EXAMPLE 1
```
$Instance = New-SqlTestLocalInstance
PS> Remove-SqlTestLocalInstance -Server $Instance
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
