---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version:
schema: 2.0.0
---

# New-SqlTestDockerInstance

## SYNOPSIS
Returns connection parameter for a SQL server in a new Docker container.

## SYNTAX

```
New-SqlTestDockerInstance [-DockerContainerName <String>] [-ServerAdminPassword <String>] [-AcceptEula]
 [-Timeout <Int32>] [-Port <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Creates a Docker container with a SQL server installed.
Returns a object with the properties DataSource and ConnectionString.

## EXAMPLES

### EXAMPLE 1
```
New-SqlTestDockerInstance -AcceptEula
Name             : Sandbox
Hostname         : localhost
UserId           : sa
ConnectionString : Server='localhost';Encrypt=False;User Id='sa';Password='pa$$w0rd'
IsDocker         : True
Id               : 693d5e79169c50af4ab5b10e1af9069a987ec8902033f3c55f325e12199a61c1
Names            : {Sandbox}
Image            : mcr.microsoft.com/mssql/server
Command          : "/opt/mssql/bin/permissions_check.sh /opt/mssql/bin/sqlservr"
LocalVolumes     : {0}
Labels           : {com.microsoft.product=Microsoft SQL Server, com.microsoft.version=15.0.4153.1, vendor=Microsoft}
Mounts           : {}
Networks         : {bridge}
Ports            : {0.0.0.0:1433->1433/tcp}
CreatedAt        : 2021-12-01 00:00:00 +0100 CET
RunningFor       : 2 seconds ago
Status           : Up 1 second
Size             : 0B (virtual 1.54GB)
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
