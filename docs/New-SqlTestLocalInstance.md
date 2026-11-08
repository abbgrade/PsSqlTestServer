---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestLocalInstance.html
schema: 2.0.0
---

# New-SqlTestLocalInstance

## SYNOPSIS
Creates a LocalDB instance and returns its connection parameters.
Requires PsSqlLocalDb and an installed LocalDB utility.

## SYNTAX

```
New-SqlTestLocalInstance [[-Name] <String>] [[-Version] <Version>] [-Connected]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uses \[SqlLocalDB Utility\](https://docs.microsoft.com/en-us/sql/tools/sqllocaldb-utility?view=sql-server-ver15) to get info about the available local db.

## EXAMPLES

### EXAMPLE 1
```
$instance = New-SqlTestLocalInstance
Creates a temporary LocalDB instance. The selected SQL Server version depends on the versions installed locally.
Captured output (temporary instance name redacted; the installed version may vary):
```

Name             : test-\<redacted\>
Version          : 15.0.4382.1
DataSource       : (LocalDb)\test-\<redacted\>
ConnectTimeout   : 30
ConnectionString : Data Source=(LocalDb)\test-\<redacted\>;Connect Timeout=30;Integrated Security=True
IsLocalDb        : True
PS\> $instance | Remove-SqlTestLocalInstance
Removes the LocalDB instance created by this example.

## PARAMETERS

### -Name
Specifies the name of the instance to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ( New-DatabaseName )
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Specifies the version of the sql server.

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestLocalInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestLocalInstance.html)

