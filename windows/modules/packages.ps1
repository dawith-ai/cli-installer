function Install-BaseTools {
    param([bool]$InstallPython = $true, [bool]$InstallGit = $true)
    Assert-Winget
    Install-WingetPackage -Id 'OpenJS.NodeJS.LTS' -Name 'Node.js (LTS)' -Command 'node'
    if ($InstallPython) { Install-WingetPackage -Id 'Python.Python.3.13' -Name 'Python' -Command 'python' }
    if ($InstallGit) { Install-WingetPackage -Id 'Git.Git' -Name 'Git for Windows' -Command 'git' }
    Install-WingetPackage -Id 'Microsoft.VisualStudioCode' -Name 'Visual Studio Code' -Command 'code'
}
