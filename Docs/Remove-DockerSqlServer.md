---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-DockerSqlServer

## SYNOPSIS
Removes a test SQL server Docker container.

## SYNTAX

```
Remove-DockerSqlServer [-DockerContainerName] <String> [<CommonParameters>]
```

## DESCRIPTION
Removes a SQL server Docker container, in case it was created with `New-DockerSqlServer`.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-Module PsSqlTestServer
PS C:\> $server = New-DockerSqlServer -DockerContainerName 'Sandbox' -ServerAdminPassword 'pa$$w0rd' -AcceptEula
PS C:\> Remove-DockerSqlServer -DockerContainerName $server.Name
```

## PARAMETERS

### -DockerContainerName
Specifies the name of the new Docker container.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
