#requires -Version 5.1

[CmdletBinding()]
param(
    [ValidateSet('Essential', 'All', 'Custom')]
    [string]$Profile = "Essential",

    [string[]]$Tools = @(),

    [switch]$SkipPython,

    [switch]$SkipGit,

    [switch]$NoPrompt
)


$ErrorActionPreference = "Stop"


Write-Host ""
Write-Host "=== OneShot AI 개발환경 설치 ===" -ForegroundColor Cyan
Write-Host "Profile : $Profile"
Write-Host ""


$scriptUrl = "https://raw.githubusercontent.com/dawith-ai/cli-installer/main/windows/install.ps1"


try {

    Write-Host "Windows 설치 스크립트 다운로드..." -ForegroundColor Yellow


    $tempFile = Join-Path $env:TEMP "oneshot-windows-install.ps1"


    Invoke-WebRequest `
        -Uri $scriptUrl `
        -OutFile $tempFile


    & $tempFile `
    -Profile $Profile `
    -Tools $Tools `
    -SkipGit:$SkipGit `
    -SkipPython:$SkipPython `
    -NoPrompt:$NoPrompt


}
catch {

    Write-Host ""
    Write-Host "설치 실패" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

}


Write-Host ""
Write-Host "설치 과정 종료" -ForegroundColor Green
Write-Host ""
