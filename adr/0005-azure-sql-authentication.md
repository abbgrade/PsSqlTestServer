# 0005: Use Entra-only authentication for Azure SQL test servers

## Context and Problem Statement

The Azure SQL backend uses the developer's authenticated Azure context. When
the authentication method is not important to a test, Active Directory
Integrated authentication is the most convenient option. Tests that need
username-and-password authentication can use the Docker backend instead of
requiring SQL authentication on Azure.

## Considered Options

* Create Azure SQL servers with Microsoft Entra-only authentication and use
  integrated authentication in the connection string.
* Configure SQL authentication with a module-managed administrator password.
* Leave authentication mode to an external configuration step.

## Decision Outcome

Chosen option: "Create Azure SQL servers with Microsoft Entra-only
authentication and use integrated authentication in the connection string."
The server is created with `-EnableActiveDirectoryOnlyAuthentication`; the
signed-in Azure identity is configured as the external administrator, and the
returned connection string uses `Authentication=Active Directory Integrated`.
Active Directory Integrated is preferred for convenience when the
authentication method is not under test. For tests that need SQL
username-and-password authentication, use the Docker backend.

### Consequences

* Good, because the Azure backend uses the existing Azure sign-in instead of
  introducing a SQL administrator password.
* Good, because the Docker backend provides a way to test SQL
  username-and-password authentication.
* Bad, because callers must authenticate to Azure and the identity must be
  authorized for the SQL server.
* Bad, because tests of SQL username-and-password authentication on Azure
  itself require a different authentication design.

Evidence: [New-AzureInstance](../src/Public/New-AzureInstance.ps1),
[New-DockerInstance](../src/Public/New-DockerInstance.ps1).
