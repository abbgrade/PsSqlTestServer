task InstallBuildDependencies -Jobs {
    Install-Module platyPs -Scope CurrentUser -ErrorAction Stop -Verbose
}

task InstallTestDependencies -Jobs {
    Install-Module psdocker -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease
    Install-Module PsSqlLocalDb -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease
    Install-Module PsSqlClient -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease -AllowClobber
}

task InstallReleaseDependencies -Jobs {
}
