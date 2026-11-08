---
external help file: PsSqlTestServer-help.xml
Module Name: PsSqlTestServer
online version: https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureDatabase.html
schema: 2.0.0
---

# New-SqlTestAzureDatabase

## SYNOPSIS
Creates a new Azure SQL Database and returns the connection parameters.

## SYNTAX

### UseServer
```
New-SqlTestAzureDatabase -Server <Object> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NewServer
```
New-SqlTestAzureDatabase -Subscription <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a database for temporary use on an existing Azure SQL Server.
Requires Az modules and an authenticated
Azure context.
When creating a server with -Subscription, the returned database has a RemoveServer property
that allows Remove-SqlTestAzureDatabase to remove the server as well.

## EXAMPLES

### EXAMPLE 1
```
Connect-AzAccount
PS> $instance = New-SqlTestAzureInstance -FirewallRule justme
PS> $database = New-SqlTestAzureDatabase -Server $instance
Creates a temporary database on the specified Azure SQL Server.
Captured output (temporary server and database names redacted):
```

DatabaseName     : \<redacted\>
DataSource       : \<redacted\>.database.windows.net
InitialCatalog   : \<redacted\>
ConnectTimeout   : 30
ConnectionString : Data Source=\<redacted\>.database.windows.net;Connect Timeout=30;Initial Catalog=\<redacted\>
PS\> $database | Remove-SqlTestAzureDatabase
PS\> $instance | Remove-SqlTestAzureInstance
Removes the database and the server created for this example.

## PARAMETERS

### -Server
Specifies the Azure SQL Server.
\[Microsoft.Azure.Commands.Sql.Server.Model.AzureSqlServerModel\]

```yaml
Type: Object
Parameter Sets: UseServer
Aliases: Instance

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subscription
Specifies the Azure Subscription name.

```yaml
Type: String
Parameter Sets: NewServer
Aliases:

Required: True
Position: Named
Default value: None
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

[https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureDatabase.html](https://abbgrade.github.io/PsSqlTestServer/docs/New-SqlTestAzureDatabase.html)

