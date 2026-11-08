---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabase.html
schema: 2.0.0
---

# New-SqlTestDatabase

## SYNOPSIS
Creates a new database and returns the connection parameters.

## SYNTAX

```
New-SqlTestDatabase [-Instance] <PSObject> [-InstanceConnection] <SqlConnection> [[-Name] <String>]
 [-Connected] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a database for temporary use on an existing SQL Server instance.
The returned object includes the
instance connection for later database removal.
Use -Connected to also open and return a database connection.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestInstance
PS> $instanceConnection = $instance | Connect-TSqlInstance
PS> $database = New-SqlTestDatabase -Instance $instance -InstanceConnection $instanceConnection
Creates a temporary database on the SQL Server instance.
Captured output (temporary database and instance names redacted):
```

Name             : test-\<redacted\>
Version          : 15.0.4382.1
DataSource       : (LocalDb)\test-\<redacted\>
ConnectTimeout   : 30
InitialCatalog   : test-\<redacted\>
ConnectionString : Data Source=(LocalDb)\test-\<redacted\>;Connect Timeout=30;Integrated Security=True;Initial Catalog=test-\<redacted\>

PS\> $database | Remove-SqlTestDatabase
PS\> Disconnect-TSqlInstance -Connection $instanceConnection
PS\> $instance | Remove-SqlTestInstance
Removes the database, closes the instance connection, and removes the server instance.

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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -InstanceConnection
Specifies an open SQL connection to the instance.

```yaml
Type: SqlConnection
Parameter Sets: (All)
Aliases: Connection

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: ( New-DatabaseName )
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connected
Specifies whether a SqlClient connection should be created.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

## NOTES

## RELATED LINKS

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabase.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDatabase.html)

