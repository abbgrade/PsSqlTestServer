# 0003: Use unique-by-default names for test resources

## Context and Problem Statement

Tests may create SQL Server instances and databases on shared machines or
services. Reusing fixed default names risks collisions between test runs, while
callers also need returned information to connect to and explicitly remove
resources.

## Considered Options

* Generate GUID-based default names and return resource metadata for later
  connection and cleanup.
* Use fixed default names and require callers to coordinate their use.
* Generate names but do not retain provider metadata on the returned objects.

## Decision Outcome

Chosen option: "Generate GUID-based default names and return resource metadata
for later connection and cleanup." Docker containers, LocalDB instances, and
databases use generated names by default. Provider commands return objects
containing connection information, and provider-aware removal commands clean
up instances; database removal is a separate operation. Callers may provide
names explicitly. This rationale is inferred from the current implementation.

### Consequences

* Good, because default resource names are unlikely to collide across test
  runs.
* Good, because returned connection and instance metadata supports subsequent
  use and cleanup.
* Bad, because callers remain responsible for invoking cleanup; Azure resource
  group lifecycle is separate from individual server cleanup.
* Bad, because randomly generated names are less convenient to inspect than
  fixed names.

Evidence: [New-DatabaseName](../src/Public/New-DatabaseName.ps1),
[New-LocalInstance](../src/Public/New-LocalInstance.ps1),
[New-DockerInstance](../src/Public/New-DockerInstance.ps1),
[New-Database](../src/Public/New-Database.ps1),
[Remove-Instance](../src/Public/Remove-Instance.ps1).
