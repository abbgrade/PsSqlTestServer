# 0004: Select Docker images and readiness checks by host architecture

## Context and Problem Statement

The Docker backend can run SQL Server images for different container operating
systems. Their image names, password environment variables, and startup
signals differ, so one fixed image and readiness check cannot serve both
supported architectures.

## Considered Options

* Select a compatible image and startup probe based on the Docker server
  architecture.
* Use one image and one readiness probe for every Docker server.
* Support only one Docker server architecture.

## Decision Outcome

Chosen option: "Select a compatible image and startup probe based on the Docker
server architecture." The module currently maps Linux/amd64 and Windows/amd64
to separate image and password settings and corresponding readiness commands.
This rationale is inferred from the current implementation.

### Consequences

* Good, because the Docker backend can support both configured server
  architectures using their respective startup signals.
* Bad, because each supported architecture needs its own maintained
  configuration and readiness behavior.
* Bad, because unsupported architectures fail rather than falling back to an
  unverified configuration.

Evidence: [Get-SqlDockerParameter](../src/Internal/Get-SqlDockerParameter.ps1),
[Wait-LinuxDockerSqlServer](../src/Internal/Wait-LinuxDockerSqlServer.ps1),
[Wait-WindowsDockerSqlServer](../src/Internal/Wait-WindowsDockerSqlServer.ps1),
[New-DockerInstance](../src/Public/New-DockerInstance.ps1).
