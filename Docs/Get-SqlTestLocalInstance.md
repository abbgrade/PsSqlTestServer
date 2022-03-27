---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Get-SqlTestLocalInstance

## SYNOPSIS
Returns connection parameters to a available localDb.

## SYNTAX

```
Get-SqlTestLocalInstance [[-First] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Uses \[SqlLocalDB Utility\](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

## EXAMPLES

### EXAMPLE 1
```
Get-SqlTestLocalInstance
```

\[PSCustomObject\]

Name                           Value
----                           -----
DataSource                     (LocalDb)\MSSQLLocalDB
ConnectionString               Data Source=(LocalDb)\MSSQLLocalDB;Integrated Security=True
Version                        v11.0

## PARAMETERS

### -First
Specifies maximum number of returned instances.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
