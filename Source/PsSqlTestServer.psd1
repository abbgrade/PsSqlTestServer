@{
    RootModule = 'PsSqlTestServer.psm1'
    ModuleVersion = '0.2.0'
    GUID = 'e08af4c8-1485-42c3-a85b-67e2e68636b4'
    Author = 'Steffen Kampmann'
    Copyright = '(c) 2021 s.kampmann. Alle Rechte vorbehalten.'
    Description = 'Cmdlets to provide and manage SQL servers for tests.'
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = '*'
    PrivateData = @{
        PSData = @{
            Tags = @('sql-server')
            LicenseUri = 'https://github.com/abbgrade/PsSqlTestServer/blob/master/LICENSE'
            ProjectUri = 'https://github.com/abbgrade/PsSqlTestServer'
        }
    }
    DefaultCommandPrefix = ''
}
