# Readme

PsSqlTestServer provides commands to manage SQL servers for tests.

For details, visit the [GitHub Pages](https://abbgrade.github.io/PsSqlTestServer/).

## Usage

See [the command reference](./docs/) for descriptions and examples.

## Changelog

See the [changelog](./CHANGELOG.md) file.

## Installation

This module can be installed from [PsGallery](https://www.powershellgallery.com/packages/PsSqlTestServer).

```powershell
Install-Module -Name PsSqlTestServer -AllowPrerelease
```

Alternatively it can be built and installed from the sources:

1. Install the development dependencies
2. Download or clone it from GitHub
3. Run the installation task:

```powershell
Invoke-Build Install
```

### Compatibility

The Az modules are not required to install or use non-Azure features.

| Module | [Az 12.0.0](https://www.powershellgallery.com/packages/Az/12.0.0) | [Az 12.5.0](https://www.powershellgallery.com/packages/Az/12.5.0) (latest 12.x) | [Az 14.0.0](https://www.powershellgallery.com/packages/Az/14.0.0) | [Az 14.6.0](https://www.powershellgallery.com/packages/Az/14.6.0) (latest 14.x) |
| --- | --- | --- | --- | --- |
| `Az.Accounts` | 3.0.0 or later | 3.0.5 or later | 5.0.0 or later | 5.3.0 or later |
| `Az.Resources` | 7.1.0 | 7.6.0 | 8.0.0 | 8.1.1 |
| `Az.Sql` | 5.0.0 | 5.3.0 | 6.0.4 | 6.3.0 |

#### Az 14 (LTS) - latest

```powershell
Install-Module -Name Az.Accounts -RequiredVersion 5.3.0
Install-Module -Name Az.Resources -RequiredVersion 8.1.1
Install-Module -Name Az.Sql -RequiredVersion 6.3.0
```

#### Az 14 (LTS) - initial

```powershell
Install-Module -Name Az.Accounts -RequiredVersion 5.0.0
Install-Module -Name Az.Resources -RequiredVersion 8.0.0
Install-Module -Name Az.Sql -RequiredVersion 6.0.4
```

#### Az 12 (LTS) - latest

```powershell
Install-Module -Name Az.Accounts -RequiredVersion 3.0.5
Install-Module -Name Az.Resources -RequiredVersion 7.6.0
Install-Module -Name Az.Sql -RequiredVersion 5.3.0
```

#### Az 12 (LTS) - initial

```powershell
Install-Module -Name Az.Accounts -RequiredVersion 3.0.0
Install-Module -Name Az.Resources -RequiredVersion 7.1.0
Install-Module -Name Az.Sql -RequiredVersion 5.0.0
```

## Development

- This is a [Portable Module](https://docs.microsoft.com/de-de/powershell/scripting/dev-cross-plat/writing-portable-modules?view=powershell-7).
- [VSCode](https://code.visualstudio.com) is recommended as IDE. [VSCode Tasks](https://code.visualstudio.com/docs/editor/tasks) are configured.
- Build automation is based on [InvokeBuild](https://github.com/nightroman/Invoke-Build)
- Test automation is based on [Pester](https://pester.dev)
- Azure tests can use a local, Git-ignored `.PsSqlTestServer.settings.json` file
  in the repository root:

  ```json
  {
      "AzureSubscription": "My Azure subscription"
  }
  ```

  The `PSSQLTESTSERVER_AZURE_SUBSCRIPTION` environment variable takes precedence
  over this file. If neither is configured, tests use `Visual Studio`. For example:

  ```powershell
  $env:PSSQLTESTSERVER_AZURE_SUBSCRIPTION = 'My Azure subscription'
  Invoke-Pester
  ```
- Azure integration tests create SQL servers. Set `PSSQLTESTSERVER_AZURE_LOCATION`
  to a region where your subscription can create SQL servers (for example,
  `northeurope`). Without it, the existing resource group's location is used.
  If the group does not exist, the variable is required for tests that create
  servers directly. Region availability depends on the subscription.
  The `New-SqlTestAzureDatabase -Subscription` integration test creates its own
  server internally and cannot pass this location override; it requires an
  existing `PsSqlTestServer` resource group in a usable region.
  To troubleshoot provisioning, enable verbose output for the test run:

  ```powershell
  & { $VerbosePreference = 'Continue'; Invoke-Pester -Path .\test\Get-AzureInstance.Tests.ps1 }
  ```

  Verbose output includes Azure account and resource identifiers; review it
  before sharing.
- Commands are named based on [Approved Verbs for PowerShell Commands](https://docs.microsoft.com/de-de/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands)
- This project uses [git-flow](https://github.com/nvie/gitflow).
- This project uses [keep a changelog](https://keepachangelog.com/en/1.0.0/).
- This project uses [PsBuildTasks](https://github.com/abbgrade/PsBuildTasks).

### Build

The build scripts require InvokeBuild. If it is not installed, install it with the command `Install-Module InvokeBuild`.

You can build the module using the VS Code build task or with the command `Invoke-Build Build`.

### Release

1. Create a release branch using git-flow.
2. Update the version number in the module manifest.
3. Extend the changelog in `CHANGELOG.md`.
4. If you want to create a pre-release.
   1. Push the release branch to GitHub, to publish the pre-release to PsGallery.
5. Finish release using git-flow.
6. Check if tags are not pushed to GitHub.
7. Check if the release branch is deleted on GitHub.
8. Create the release on GitHub.
