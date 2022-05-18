---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# New-SqlTestDatabase

## SYNOPSIS
Creates a new database and returns the connection parameters.

## SYNTAX

```
New-SqlTestDatabase [-Instance] <PSObject> [-InstanceConnection] <SqlConnection> [[-Name] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Uses a existing test instance and creates a database for (temporary) use.
It keeps an open connection to the instance for later removal.

## EXAMPLES

### EXAMPLE 1
```
$Instance = New-SqlTestInstance
PS> $InstanceConnection = $Instance | Connect-TSqlInstance
PS> New-SqlTestDatabase -Instance $Instance -InstanceConnection $InstanceConnection
```

ConnectionString   : Data Source=(LocalDb)\MSSQLLocalDB;Connect Timeout=30;Integrated Security=True;Initial Catalog=a48b028c
DataSource         : (LocalDb)\MSSQLLocalDB
ConnectTimeout     : 30
Version            : v11.0
InitialCatalog     : a48b028c
InstanceConnection : Microsoft.Data.SqlClient.SqlConnection

## PARAMETERS

### -Instance
Specifies the instance, to create the database in.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceConnection
Specifies a open sql connection to the instance.

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the database to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: ( [string](New-Guid) ).Substring(0, 8)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
