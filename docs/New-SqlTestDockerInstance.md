---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDockerInstance.html
schema: 2.0.0
---

# New-SqlTestDockerInstance

## SYNOPSIS
Returns connection parameter for a SQL server in a new Docker container.

## SYNTAX

```
New-SqlTestDockerInstance [-DockerContainerName <String>] [-ServerAdminPassword <String>] [-AcceptEula]
 [-Timeout <Int32>] [-Port <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a Docker container with SQL Server and returns an object with connection metadata.
Requires Docker,
the psdocker module, and acceptance of the Microsoft SQL Server EULA.

## EXAMPLES

### EXAMPLE 1
```
$container = New-SqlTestDockerInstance -DockerContainerName 'sql-test' -Port 58955 -AcceptEula
Creates a SQL Server container named sql-test. Container details and mapped port depend on the local Docker environment.
Captured output (password omitted):
```

Name                   : sql-test
Hostname               : localhost
DataSource             : localhost
Port                   : 58955
UserId                 : sa
ConnectTimeout         : 30
IsDocker               : True
TrustServerCertificate : True

PS\> $container | Remove-SqlTestDockerInstance
Removes the container created by this example.

## PARAMETERS

### -DockerContainerName
Specifies the name of the new Docker container.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ( ( New-Guid ).ToString().Substring(0, 8) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerAdminPassword
Specifies the password for the sa user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Pa$$w0rd!
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcceptEula
Confirms your acceptance of the \[End-User Licensing Agreement\](https://go.microsoft.com/fwlink/?linkid=857698).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Specifies the seconds to wait for the SQL service.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Specifies the port to map the sql server to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1433
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

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDockerInstance.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestDockerInstance.html)

