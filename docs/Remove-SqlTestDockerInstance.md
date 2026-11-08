---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDockerInstance.html
schema: 2.0.0
---

# Remove-SqlTestDockerInstance

## SYNOPSIS
Removes a test SQL server Docker container.

## SYNTAX

```
Remove-SqlTestDockerInstance -Server <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Removes a SQL Server Docker container created by New-SqlTestDockerInstance.
Requires Docker and the psdocker module.

## EXAMPLES

### EXAMPLE 1
```
$container = New-SqlTestDockerInstance -DockerContainerName 'sql-test' -AcceptEula
PS> $container | Remove-SqlTestDockerInstance
Removes the container created by this example.
Illustrative output: the container is removed; output depends on the psdocker version.
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

[https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDockerInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/Remove-SqlTestDockerInstance.html)

