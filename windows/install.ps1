#requires -Version 5.1

[CmdletBinding()]

param(
    [ValidateSet('Essential','All','Custom')]
    [string]$Profile = "Essential",

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



function Refresh-Path {


    $machinePath =
    [Environment]::GetEnvironmentVariable(
        "Path",
        "Machine"
    )


    $userPath =
    [Environment]::GetEnvironmentVariable(
        "Path",
        "User"
    )


    $env:Path =
    "$machinePath;$userPath"


    $env:Path += ";C:\Program Files\nodejs"

    $env:Path += ";$env:APPDATA\npm"

}



function Install-BaseTools {


    Write-Step "기본 개발 도구 설치"


    if(!$SkipGit){

        Write-Host "Git 설치 중..."

        winget install `
        --id Git.Git `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    }


    Write-Host "Node.js 설치 중..."

    winget install `
    --id OpenJS.NodeJS.LTS `
    --silent `
    --accept-package-agreements `
    --accept-source-agreements


    Refresh-Path


    if(Get-Command npm.cmd -ErrorAction SilentlyContinue){

        Write-Host "npm 설치 확인 완료" -ForegroundColor Green

    }
    else {

        Write-Host "npm 확인 실패" -ForegroundColor Yellow

    }

}



function Select-AITools {


    Write-Host ""

    Write-Host "설치할 AI CLI를 선택하세요." `
    -ForegroundColor Cyan


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


            "1" {
                $selected += "claude"
            }


            "2" {
                $selected += "codex"
            }


            "3" {
                $selected += "gemini"
            }


            "4" {

                return @(
                    "claude",
                    "codex",
                    "gemini"
                )

            }

        }

    }


    if($selected.Count -eq 0){

        Write-Host "잘못된 선택입니다."

        return Select-AITools

    }


    return $selected

}



function Install-Claude {


    Write-Step "Claude Code 설치"


    npm.cmd install -g @anthropic-ai/claude-code


}



function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    npm.cmd install -g @openai/codex


}



function Install-Gemini {


    Write-Step "Gemini CLI 설치"


    npm.cmd install -g @google/gemini-cli


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



Refresh-Path



Write-Host ""

Write-Host "설치 완료!" `
-ForegroundColor Green


Write-Host ""

Write-Host "사용 가능한 명령어:" `
-ForegroundColor Cyan


foreach($tool in $selected){

    Write-Host $tool

}


Write-Host ""
