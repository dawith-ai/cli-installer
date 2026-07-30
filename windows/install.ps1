#requires -Version 5.1
[CmdletBinding()]
param(
    [string[]]$Tools = @(),
    [switch]$SkipGit,
    [switch]$NoPrompt
)
$ErrorActionPreference = "Continue"

function Ensure-ExecutionPolicy {
    $current = Get-ExecutionPolicy -Scope CurrentUser
    if ($current -eq "Restricted" -or $current -eq "Undefined" -or $current -eq "AllSigned") {
        try {
            Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
            Write-Host "실행 정책을 설정했습니다." -ForegroundColor Green
        }
        catch {
            Write-Host "실행 정책 설정에 실패했습니다. 문제가 계속되면 PowerShell을 관리자 권한으로 다시 실행해주세요." -ForegroundColor Yellow
        }
    }
}

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
    else {
        Write-Host "Node.js 설치 중..."
        winget install `
            --id OpenJS.NodeJS.LTS `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements
        if($LASTEXITCODE -eq 0){
            Write-Host "Node.js 설치 완료" -ForegroundColor Green
        }
        else {
            Write-Host "Node.js 설치를 완료하지 못했습니다. 나중에 다시 시도해주세요." -ForegroundColor Yellow
        }
    }

    Refresh-Path

    if(Test-CommandExists "npm.cmd"){
        Write-Host "npm 설치 확인 완료" -ForegroundColor Green
    }
    else {
        Write-Host "npm을 아직 찾을 수 없습니다. 설치가 끝난 뒤 새 터미널을 열어 다시 실행해주세요." -ForegroundColor Yellow
    }
}

function Select-AITools {
    if($NoPrompt){
        if($Tools.Count -gt 0){
            return $Tools
        }
        return @("claude", "codex", "gemini")
    }

    while($true){
        Write-Host ""
        Write-Host "설치할 AI CLI를 선택하세요." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "[1] Claude Code"
        Write-Host "[2] OpenAI Codex"
        Write-Host "[3] Gemini CLI"
        Write-Host "[4] 전체 설치"
        Write-Host ""

        $choice = Read-Host "선택 (예: 1,2)"
        $selected = @()

        foreach($item in $choice.Split(",")){
            switch($item.Trim()){
                "1" { $selected += "claude" }
                "2" { $selected += "codex" }
                "3" { $selected += "gemini" }
                "4" {
                    return @("claude", "codex", "gemini")
                }
            }
        }

        if($selected.Count -gt 0){
            return $selected
        }

        Write-Host "잘못된 선택입니다. 다시 입력해주세요." -ForegroundColor Yellow
    }
}

function Install-NpmTool {
    param(
        [string]$PackageName,
        [string]$DisplayName,
        [string]$Command
    )

    Write-Step "$DisplayName 설치"

    if(!(Test-CommandExists "npm.cmd")){
        Write-Host "npm을 찾을 수 없어 $DisplayName 설치를 건너뜁니다. Node.js 설치 후 새 터미널에서 다시 실행해주세요." -ForegroundColor Yellow
        return
    }

    if(Test-CommandExists $Command){
        Write-Host "$DisplayName가 이미 설치되어 있습니다. 건너뜁니다." -ForegroundColor Green
        return
    }

    npm.cmd install -g $PackageName

    if($LASTEXITCODE -eq 0){
        Write-Host "$DisplayName 설치 완료" -ForegroundColor Green
    }
    else {
        Write-Host "$DisplayName 설치 중 문제가 발생했습니다. 네트워크 상태를 확인한 뒤 다시 시도해주세요." -ForegroundColor Yellow
    }
}

Write-Step "CLI Installer 시작"

Ensure-ExecutionPolicy

Install-BaseTools

$selected = Select-AITools

foreach($tool in $selected){
    switch($tool){
        "claude" { Install-NpmTool -PackageName "@anthropic-ai/claude-code" -DisplayName "Claude Code" -Command "claude" }
        "codex"  { Install-NpmTool -PackageName "@openai/codex" -DisplayName "OpenAI Codex" -Command "codex" }
        "gemini" { Install-NpmTool -PackageName "@google/gemini-cli" -DisplayName "Gemini CLI" -Command "gemini" }
    }
}

Refresh-Path

Write-Host ""
Write-Host "설치 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "사용 가능한 명령어:" -ForegroundColor Cyan

foreach($tool in $selected){
    Write-Host $tool
}

Write-Host ""

if(!$NoPrompt){
    Write-Host "새 창에서 방금 설치한 명령어를 바로 사용할 수 있도록 준비합니다..." -ForegroundColor Cyan
    Write-Host "(지금 이 창은 닫으셔도 됩니다)" -ForegroundColor Yellow
    Start-Process powershell.exe -WorkingDirectory $env:USERPROFILE
}

Write-Host ""
