#requires -Version 5.1

[CmdletBinding()]

param(

    [ValidateSet('Essential','All','Custom')]
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


    $machine =
    [Environment]::GetEnvironmentVariable(
        "Path",
        "Machine"
    )


    $user =
    [Environment]::GetEnvironmentVariable(
        "Path",
        "User"
    )


    $env:Path="$machine;$user"


    $extra=@(
        "C:\Program Files\nodejs",
        "$env:APPDATA\npm"
    )


    foreach($p in $extra){

        if(Test-Path $p){

            $env:Path += ";$p"

        }

    }

}



function Install-BaseTools {


    Write-Step "기본 개발 도구 설치"


    if(!$SkipGit){

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

    if(Get-Command node.exe -ErrorAction SilentlyContinue){

        Write-Host "Node 설치 확인 완료" -ForegroundColor Green

    }


    if(Get-Command npm.cmd -ErrorAction SilentlyContinue){

        Write-Host "npm 설치 확인 완료" -ForegroundColor Green

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



    switch($choice){

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
            return @(
                "claude",
                "codex",
                "gemini"
            )
        }


        default {

            return Select-AITools

        }

    }

}



function Install-Claude {


    Write-Step "Claude Code 설치"


    Refresh-Path


    npm.cmd install --global @anthropic-ai/claude-code

}



function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    Refresh-Path


    npm.cmd install --global @openai/codex

}



function Install-Gemini {


    Write-Step "Gemini CLI 설치"


    Refresh-Path


    npm.cmd install --global @google/gemini-cli

}




Write-Step "OneShot AI 개발환경 시작"



Install-BaseTools



$selected = Select-AITools



foreach($tool in $selected){


    switch($tool){


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

Write-Host "설치 완료!" -ForegroundColor Green


Write-Host ""

Write-Host "사용 가능한 명령어:"

Write-Host " claude"

Write-Host " codex"

Write-Host " gemini"

Write-Host ""
