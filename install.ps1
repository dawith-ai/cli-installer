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


$baseUrl = "https://raw.githubusercontent.com/dawith-ai/cli-installer/main/windows"


try {

    Write-Host "Windows 설치 스크립트 다운로드..." -ForegroundColor Yellow


    Invoke-RestMethod `
        "$baseUrl/install.ps1" |
        Invoke-Expression


}
catch {

    Write-Host ""
    Write-Host "설치 실패" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1
}


Write-Host ""
Write-Host "설치 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "사용 가능한 명령어:"
Write-Host "  claude"
Write-Host "  codex"
