#requires -Version 5.1

[CmdletBinding()]
param(
    [ValidateSet('Essential', 'All', 'Custom')]
    [string]$Profile = 'Essential',

    [string[]]$Tools = @(),

    [switch]$SkipPython,

    [switch]$SkipGit,

    [switch]$NoPrompt
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== OneShot AI 개발환경 설치 ===" -ForegroundColor Cyan
Write-Host "Profile: $Profile"
Write-Host ""

$sourceBase = "https://raw.githubusercontent.com/dawith-ai/cli-installer/main"

try {

    Write-Host "설치 스크립트를 불러오는 중..." -ForegroundColor Yellow

    $installScript = Invoke-RestMethod `
        -Uri "$sourceBase/windows/install.ps1" `
        -ErrorAction Stop

    Write-Host "Windows 설치 시작..." -ForegroundColor Green
    Write-Host ""

    & ([scriptblock]::Create($installScript)) `
        -Profile $Profile `
        -Tools $Tools `
        -SkipPython:$SkipPython `
        -SkipGit:$SkipGit `
        -NoPrompt:$NoPrompt

}
catch {

    Write-Host ""
    Write-Host "설치 실패" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1
}

Write-Host ""
Write-Host "설치가 완료되었습니다." -ForegroundColor Green
Write-Host ""
Write-Host "새 프로젝트 폴더에서 아래 명령어로 시작하세요." -ForegroundColor Cyan
Write-Host ""
Write-Host "  claude"
Write-Host "  codex"
