# 0002: Keep provider integrations optional and share SQL connection metadata

## Context and Problem Statement

The module offers multiple ways to provide SQL Server instances, but not every
user or test environment needs every provider. Avoid unnecessary dependencies:
for example, users who do not test against Azure should not have to install the
Az modules. Common SQL operations also need a consistent way to connect to
instances.

## Considered Options

* Require all provider modules for every installation and expose only a
  provider-neutral interface.
* Keep provider dependencies optional and return shared SQL connection
  metadata alongside provider-specific data.
* Implement each provider as a separate module with no shared connection shape.

## Decision Outcome

Chosen option: "Keep provider dependencies optional and return shared SQL
connection metadata alongside provider-specific data." The module manifest
requires `PsSqlClient`, while LocalDB and Docker commands load their respective
modules on demand and Azure commands use the Az modules. This avoids requiring
the Az modules for users who do not test against Azure. Instance objects expose
connection properties such as `DataSource`, `ConnectionString`, and
`ConnectTimeout`; provider-specific commands and properties remain available
where needed. The rationale for the shared connection metadata is inferred
from the current implementation.

### Consequences

* Good, because installations need only the dependencies for the backends they
  use.
* Good, because shared SQL client operations can consume connection metadata
  across providers.
* Bad, because the shared object shape is implemented by convention rather
  than a statically enforced provider interface.
* Bad, because provider commands still need backend-specific behavior.

Evidence: [module manifest](../src/PsSqlTestServer.psd1),
[New-LocalInstance](../src/Public/New-LocalInstance.ps1),
[New-DockerInstance](../src/Public/New-DockerInstance.ps1),
[New-Database](../src/Public/New-Database.ps1).
