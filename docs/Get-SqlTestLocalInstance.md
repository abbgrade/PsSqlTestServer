---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestLocalInstance.html
schema: 2.0.0
---

# Get-SqlTestLocalInstance

## SYNOPSIS
Returns connection parameters for an available LocalDB instance.

## SYNTAX

```
Get-SqlTestLocalInstance [[-First] <Int32>] [[-Version] <Version>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Uses PsSqlLocalDb and the \[SqlLocalDB utility\](https://learn.microsoft.com/sql/tools/sqllocaldb-utility)
to retrieve available LocalDB instances.

## EXAMPLES

### EXAMPLE 1
```
Get-SqlTestLocalInstance
Gets the first available LocalDB instance. Requires PsSqlLocalDb and an installed LocalDB utility.
Captured output (instance name redacted; the installed version may vary):
```

Name             : \<redacted\>
Version          : 15.0.4382.1
DataSource       : (LocalDb)\\\<redacted\>
ConnectTimeout   : 30
ConnectionString : Data Source=(LocalDb)\\\<redacted\>;Connect Timeout=30;Integrated Security=True
IsLocalDb        : True

## PARAMETERS

### -First
Specifies maximum number of returned sql server instances.

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

### -Version
Filters the version of the returned sql server instance.

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

[https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestLocalInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestLocalInstance.html)

