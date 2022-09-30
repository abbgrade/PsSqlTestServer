task InstallBuildDependencies -Jobs {
    Install-Module platyPs -Scope CurrentUser -ErrorAction Stop -Verbose
    Install-Module PsSqlClient -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease -AllowClobber
}

task InstallTestDependencies -Jobs {
    Install-Module psdocker -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease
    Install-Module PsSqlLocalDb -Scope CurrentUser -MinimumVersion 0.3 -ErrorAction Stop -Verbose -AllowPrerelease
    Install-Module PsSqlClient -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease -AllowClobber
}

task InstallReleaseDependencies -Jobs {
    Install-Module PsSqlClient -Scope CurrentUser -ErrorAction Stop -Verbose -AllowPrerelease -AllowClobber
}
