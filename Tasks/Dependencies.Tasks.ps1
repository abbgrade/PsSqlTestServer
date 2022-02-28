task InstallBuildDependencies -Jobs {
    Install-Module platyPs -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
    Install-Module psdocker, Invoke-MsBuild -ErrorAction Stop
}, Testdata.Create

task InstallReleaseDependencies -Jobs {
}
