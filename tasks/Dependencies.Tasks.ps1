task InstallBuildDependencies -Jobs InstallReleaseDependencies, {
    Install-Module platyPs -Scope CurrentUser -ErrorAction Stop -Verbose
}

task InstallTestDependencies -Jobs InstallReleaseDependencies, {
    Install-Module psdocker -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease:$AllowPrerelease
    Install-Module PsSqlLocalDb -Scope CurrentUser -MinimumVersion 0.3 -ErrorAction Stop -Verbose -AllowPrerelease:$AllowPrerelease
}

task InstallReleaseDependencies -Jobs {
    Install-Module PsSqlClient -Scope CurrentUser -RequiredVersion 1.5.0 -ErrorAction Stop -Verbose -AllowPrerelease:$AllowPrerelease -AllowClobber
}
