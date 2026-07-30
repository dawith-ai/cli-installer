#requires -Version 5.1
[CmdletBinding()]
param(
    [string[]]$Tools = @(),
    [switch]$SkipGit,
    [switch]$NoPrompt
)
$ErrorActionPreference = "Continue"

function Write-Step {
    param(
        [string]$Message
    )
    Write-Host ""
    Write-Host "== $Message ==" -ForegroundColor Cyan
}

function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
    $env:Path += ";C:\Program Files\nodejs"
    $env:Path += ";$env:APPDATA\npm"
}

function Install-BaseTools {
    Write-Step "기본 개발 도구 설치"

    if(!(Test-CommandExists "winget")){
        Write-Host "winget을 찾을 수 없습니다." -ForegroundColor Yellow
        Write-Host "Microsoft Store에서 '앱 설치 관리자(App Installer)'를 설치한 뒤 다시 실행해주세요." -ForegroundColor Yellow
        return
    }

    if(!$SkipGit){
        if(Test-CommandExists "git"){
            Write-Host "Git이 이미 설치되어 있습니다. 건너뜁니다." -ForegroundColor Green
        }
        else {
            Write-Host "Git 설치 중..."
            winget install `
                --id Git.Git `
                --silent `
                --accept-package-agreements `
                --accept-source-agreements
            if($LASTEXITCODE -eq 0){
                Write-Host "Git 설치 완료" -ForegroundColor Green
            }
            else {
                Write-Host "Git 설치를 완료하지 못했습니다. 나중에 다시 시도해주세요." -ForegroundColor Yellow
            }
        }
    }

    if(Test-CommandExists "node"){
        Write-Host "Node.js가 이미 설치되어 있습니다. 건너뜁니다." -ForegroundColor Green
    }
