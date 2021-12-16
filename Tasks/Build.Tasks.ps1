[System.IO.DirectoryInfo] $sourcePath = "$PsScriptRoot\..\Source"
[System.IO.DirectoryInfo] $buildPath = "$PsScriptRoot\..\Build"
[System.IO.DirectoryInfo] $docPath = "$PsScriptRoot\..\Docs"
[System.IO.FileInfo] $global:Manifest = "$sourcePath\PsSqlTestServer.psd1"
[System.IO.DirectoryInfo] $moduleBuildPath = "$buildPath\PsSqlTestServer"

task Clean {
	Remove-Item $buildPath -Recurse -ErrorAction Continue
}

task Build -Jobs Clean, CopyArtefacts

task PrepareBuildPath -If ( -Not ( Test-Path $buildPath )) -Jobs {
	New-Item -Path $buildPath -ItemType Directory | Out-Null
}

task CopyArtefacts -Jobs PrepareBuildPath, {
	Copy-Item -Path $sourcePath -Destination $moduleBuildPath -Recurse
}

task UpdateDocs {
	Import-Module $global:Manifest.FullName -Force
	Remove-Item -Path $docPath/*
	New-MarkdownHelp -Module PsSqlTestServer -OutputFolder $docPath
	# Update-MarkdownHelp -Path $docPath -AlphabeticParamsOrder -Force
}

# Synopsis: Install the module.
task Install -Jobs Build, {
    $info = Import-PowerShellDataFile $global:Manifest.FullName
    $version = ([System.Version] $info.ModuleVersion)
    $name = $global:Manifest.BaseName
    $defaultModulePath = $env:PsModulePath -split ';' | Select-Object -First 1
	Write-Verbose "install $name $version to $defaultModulePath"
    $installPath = Join-Path $defaultModulePath $name $version.ToString()
    New-Item -Type Directory $installPath -Force | Out-Null
    Get-ChildItem $global:Manifest.Directory | Copy-Item -Destination $installPath -Recurse -Force
}

# Synopsis: Publish the module to PSGallery.
task Publish -Jobs Clean, Build, {
	# Publish-Module -Name PsSqlTestServer -NuGetApiKey $NuGetApiKey
    Publish-PSResource -Path $buildPath\PsSqlTestServer -APIKey $NuGetApiKey
}
