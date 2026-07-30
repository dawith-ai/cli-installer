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


$ErrorActionPreference = "Continue"



function Write-Step {

    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "== $Message ==" -ForegroundColor Cyan
}



function Refresh-Path {

    $machinePath = [Environment]::GetEnvironmentVariable(
        "Path",
        "Machine"
    )

    $userPath = [Environment]::GetEnvironmentVariable(
        "Path",
        "User"
    )


    $env:Path = "$machinePath;$userPath"


    $extra = @(
        "C:\Program Files\nodejs",
        "$env:APPDATA\npm"
    )


    foreach ($p in $extra) {

        if (Test-Path $p) {

            $env:Path += ";$p"

        }

    }

}

function Select-AITools {

    Write-Host ""
    Write-Host "설치할 AI CLI를 선택하세요." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] Claude Code"
    Write-Host "[2] OpenAI Codex"
    Write-Host "[3] Gemini CLI"
    Write-Host "[4] 전체 설치"
    Write-Host ""

    $choice = Read-Host "선택 (1-4)"


    switch ($choice) {

        "1" {
            return @("claude")
        }

        "2" {
            return @("codex")
        }

        "3" {
            return @("gemini")
        }

        "4" {
            return @("claude","codex","gemini")
        }

        default {

            Write-Host "잘못된 선택입니다."
            return Select-AITools

        }
    }
}

function Install-BaseTools {


    Write-Step "기본 개발 도구 설치"



    if (!$SkipGit) {

        Write-Host "Git 설치"


        winget install `
            --id Git.Git `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements


    }



    Write-Host "Node.js 설치"


    winget install `
        --id OpenJS.NodeJS.LTS `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements



    Refresh-Path



    Write-Host ""

    if (Get-Command node.exe -ErrorAction SilentlyContinue) {

        Write-Host "Node 설치 확인 완료" -ForegroundColor Green

    }


    if (Get-Command npm.cmd -ErrorAction SilentlyContinue) {

        Write-Host "npm 설치 확인 완료" -ForegroundColor Green

    }
    else {

        Write-Host "npm은 새 터미널에서 활성화될 수 있습니다." -ForegroundColor Yellow

    }

}



function Install-Claude {


    Write-Step "Claude Code 설치"


    Refresh-Path


    if (!(Get-Command npm.cmd -ErrorAction SilentlyContinue)) {

        Write-Host "npm 없음 - 건너뜀" -ForegroundColor Yellow

        return

    }



    npm.cmd install --global @anthropic-ai/claude-code


}



function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    Refresh-Path


    if (!(Get-Command npm.cmd -ErrorAction SilentlyContinue)) {

        Write-Host "npm 없음 - 건너뜀" -ForegroundColor Yellow

        return

    }



    npm.cmd install --global @openai/codex


}



Write-Step "OneShot AI 개발환경 시작"



Install-BaseTools


$selectedTools = Select-AITools


foreach ($tool in $selectedTools) {

    switch ($tool) {

        "claude" {
            Install-Claude
        }

        "codex" {
            Install-Codex
        }

        "gemini" {
            Install-Gemini
        }

    }
}



Write-Host ""

Write-Host "설치 과정 완료" -ForegroundColor Green

Write-Host ""

Write-Host "사용 가능한 명령어:"
Write-Host "  claude"
Write-Host "  codex"
