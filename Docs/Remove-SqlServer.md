---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlServer

## SYNOPSIS
Removes a test SQL server.

## SYNTAX

```
Remove-SqlServer [-Server <Object>] [<CommonParameters>]
```

## DESCRIPTION
Removes a SQL server, in case it was created with \`New-SqlServer\`.

## EXAMPLES

### EXAMPLE 1
```
$server = New-SqlServer
PS> Remove-SqlServer -Server $server
```

## PARAMETERS

### -Server
Specifies the server to remove.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

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
