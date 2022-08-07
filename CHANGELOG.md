# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
