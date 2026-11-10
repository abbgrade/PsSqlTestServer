# 0001: Prefer available local providers for automatic instance creation

## Context and Problem Statement

Tests need an SQL Server instance, and the module supports both local and
cloud-backed providers. LocalDB is preferred for speed; Docker is slower but
free, while Azure SQL may incur charges. Callers need an automatic option that
does not require them to choose a provider when a suitable local one is
available.

## Considered Options

* Automatically select LocalDB first and Docker second.
* Require callers to select a provider explicitly.
* Automatically provision Azure SQL when local providers are unavailable.

## Decision Outcome

Chosen option: "Automatically select LocalDB first and Docker second." The
generic `New-SqlTestInstance` checks LocalDB, then Docker, and reports an error
when neither is available. Azure SQL remains available through its explicit
provider-specific commands rather than being an automatic fallback. LocalDB
is preferred for speed, Docker is the slower free alternative, and Azure is
left to an explicit choice because it may incur charges.

### Consequences

* Good, because a local instance can be provisioned without requiring every
  caller to know which local provider is installed.
* Good, because automatic creation does not silently provision a cloud
  resource.
* Bad, because callers who need Azure SQL must use the Azure-specific command.
* Bad, because LocalDB is preferred even when a caller would rather use Docker.

Evidence: [New-Instance](../src/Public/New-Instance.ps1),
[New-AzureInstance](../src/Public/New-AzureInstance.ps1).
