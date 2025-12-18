# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.7.1] - 2025-12-18

### Changed

- Updated PsSqlClient to 2.3.1 for compatibility with Az v14.

## [1.7.0] - 2025-12-17

### Changed

- Updated PsSqlClient to 2.3.0.

### Added

- Added new command `Get-AzureInstance` that works like `New-AzureInstance` but does not create new resources but reuses existing.
- Added new parameter set to `New-AzureDatabase` that creates a server and extended `Remove-AzureDatabase` to clean up that created server.

## [1.6.0] - 2023-03-07

### Added

- Added Version filter parameter for `Get-LocalInstance`.
- Parameter to create a SqlClientConnection in `New-LocalInstance`.
- Parameter to create a SqlClientConnection in `New-Database`.

## [1.5.0] - 2022-09-30

### Added

- Parameter to specify sql server version in `New-LocalInstance`.

## [1.4.0] - 2022-09-27

## Added

- Added `Clear-LocalInstance` command.
- Added DatabaseCredential property to `New-DockerInstance`.

## [1.3.0] - 2022-08-07

### Added

- New-AzureInstance, Remove-AzureInstance and New-DatabaseName commands

### Changed

- New-AzureDatabase does not create a server anymore.

## [1.2.0] - 2022-03-27

### Added

- Commands New-LocalInstance, Remove-LocalInstance and Get-Instance.
- Parameter First Get-LocalInstance, to limit number or results.

### Changed

- New-Instance does not reuse a existing but creates a new localdb instance.
- Remove-Instance removes local db instances.

## [1.1.0] - 2022-03-27

### Added

- Commands New-Database and Remove-Database.

## [1.0.0] - 2022-03-20

### Added

- Optional Port parameter for New-DockerSqlServer.
- Commands for Azure-based test databases.

### Changed

- Added default command prefix `SqlTest`.
- Changed almost all command names.

<!-- markdownlint-configure-file {"MD024": { "siblings_only": true } } -->
