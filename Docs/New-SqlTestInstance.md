---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# New-SqlTestInstance

## SYNOPSIS
Returns connection parameter for a SQL server.

## SYNTAX

```
New-SqlTestInstance [<CommonParameters>]
```

## DESCRIPTION
Checks different versions of local db or creates a Docker container with a SQL server installed.
Returns a object with the properties DataSource and ConnectionString.

## EXAMPLES

### EXAMPLE 1
```
New-SqlTestInstance
ConnectionString                                            DataSource
----------------                                            ----------
Data Source=(LocalDb)\MSSQLLocalDB;Integrated Security=True (LocalDb)\MSSQLLocalDB
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
