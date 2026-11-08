---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestInstance.html
schema: 2.0.0
---

# Get-SqlTestInstance

## SYNOPSIS
Returns connection parameter for a SQL server.

## SYNTAX

```
Get-SqlTestInstance [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Checks whether LocalDB is available and returns its instance information.
If unavailable, writes an error.

## EXAMPLES

### EXAMPLE 1
```
Get-SqlTestInstance
Gets an available LocalDB instance. Requires PsSqlLocalDb and an installed LocalDB utility.
Captured output (instance name and version vary by environment):
```

Name             : \<redacted\>
Version          : 15.0.4382.1
DataSource       : (LocalDb)\\\<redacted\>
ConnectTimeout   : 30
ConnectionString : Data Source=(LocalDb)\\\<redacted\>;Connect Timeout=30;Integrated Security=True
IsLocalDb        : True

## PARAMETERS

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

[https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Get-SqlTestInstance.html)

