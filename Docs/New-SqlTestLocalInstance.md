---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# New-SqlTestLocalInstance

## SYNOPSIS
Returns connection parameters to new localDb.

## SYNTAX

```
New-SqlTestLocalInstance [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Uses \[SqlLocalDB Utility\](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

## EXAMPLES

### EXAMPLE 1
```
New-SqlTestLocalInstance
```

\[PSCustomObject\]

Name                           Value
----                           -----
DataSource                     (LocalDb)\test-18f57083
ConnectionString               Data Source=(LocalDb)\test-18f57083;Integrated Security=True
Version                        v11.0

## PARAMETERS

### -Name
Specifies the name of the instance to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "test-$(( [string](New-Guid) ).Substring(0, 8))"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
