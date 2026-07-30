#requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$SkipGit,
    [switch]$NoPrompt
)
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== CLI Installer 설치 ===" -ForegroundColor Cyan
Write-Host ""

try {
    $localScript = $null
    if($PSScriptRoot){
        $candidate = Join-Path $PSScriptRoot "windows\install.ps1"
        if(Test-Path $candidate){
            $localScript = $candidate
        }
    }

    if($localScript){
        Write-Host "로컬 저장소의 설치 스크립트를 사용합니다." -ForegroundColor Yellow
        & $localScript -SkipGit:$SkipGit -NoPrompt:$NoPrompt
    }
    else {
        Write-Host "Windows 설치 스크립트 다운로드..." -ForegroundColor Yellow

        $scriptUrl = "https://raw.githubusercontent.com/dawith-ai/cli-installer/main/windows/install.ps1"

        $webClient = New-Object System.Net.WebClient
        $webClient.Encoding = [System.Text.Encoding]::UTF8
        $scriptContent = $webClient.DownloadString($scriptUrl)

        $tempFile = Join-Path $env:TEMP "cli-installer-windows-install.ps1"

        # UTF-8 BOM으로 저장 (한글 텍스트 인코딩 깨짐 방지)
        $utf8WithBom = New-Object System.Text.UTF8Encoding($true)
        [System.IO.File]::WriteAllText($tempFile, $scriptContent, $utf8WithBom)

        powershell.exe `
            -ExecutionPolicy Bypass `
            -File $tempFile `
            -SkipGit:$SkipGit `
            -NoPrompt:$NoPrompt
    }
}
catch {
    Write-Host ""
    Write-Host "설치 실패" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Write-Host "설치 과정 종료" -ForegroundColor Green
Write-Host ""
