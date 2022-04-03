---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# Remove-SqlTestDockerInstance

## SYNOPSIS
Removes a test SQL server Docker container.

## SYNTAX

```
Remove-SqlTestDockerInstance -Server <Object> [<CommonParameters>]
```

## DESCRIPTION
Removes a SQL server Docker container, in case it was created with \`New-DockerSqlServer\`.

## EXAMPLES

### EXAMPLE 1
```
$server = New-SqlTestDockerInstance -DockerContainerName 'Sandbox' -ServerAdminPassword 'pa$$w0rd' -AcceptEula
PS> Remove-SqlTestDockerInstance -DockerContainerName $server.Name
```

## PARAMETERS

### -Server
Specifies the server to remove.
Requires the name of the Docker container.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
