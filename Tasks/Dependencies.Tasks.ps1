task InstallBuildDependencies -Jobs {
    Install-Module platyPs -ErrorAction Stop -Verbose
}

task InstallTestDependencies -Jobs {
    Install-Module psdocker -ErrorAction Stop -Verbose -AllowPrerelease
    Install-Module PsSqlLocalDb -ErrorAction Stop -Verbose
}

task InstallReleaseDependencies -Jobs {
}
