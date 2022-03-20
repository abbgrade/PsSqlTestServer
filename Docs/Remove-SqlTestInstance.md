---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlTestInstance

## SYNOPSIS
Removes a test SQL server.

## SYNTAX

```
Remove-SqlTestInstance -Server <Object> [<CommonParameters>]
```

## DESCRIPTION
Removes a SQL server, in case it was created with \`New-SqlTestInstance\`.

## EXAMPLES

### EXAMPLE 1
```
$server = New-SqlTestInstance
PS> Remove-SqlTestInstance -Server $server
```

## PARAMETERS

### -Server
Specifies the server to remove.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
