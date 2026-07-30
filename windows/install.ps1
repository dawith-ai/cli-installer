#requires -Version 5.1


[CmdletBinding()]

param(

    [ValidateSet('Essential','All','Custom')]
    [string]$Profile="Essential",

    [string[]]$Tools=@(),

    [switch]$SkipPython,

    [switch]$SkipGit,

    [switch]$NoPrompt

)


$ErrorActionPreference="Continue"



# npm global ps1 실행 허용
try {

    $policy = Get-ExecutionPolicy -Scope CurrentUser


    if($policy -eq "Restricted" -or $policy -eq "Undefined") {


        Set-ExecutionPolicy `
            -ExecutionPolicy RemoteSigned `
            -Scope CurrentUser `
            -Force


        Write-Host "PowerShell 실행 정책 설정 완료" `
        -ForegroundColor Green

    }

}
catch {

    Write-Host "실행 정책 설정 건너뜀" `
    -ForegroundColor Yellow

}



function Write-Step {

    param([string]$Message)

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


    $env:Path += ";C:\Program Files\nodejs"

    $env:Path += ";$env:APPDATA\npm"

}



function Install-BaseTools {


    Write-Step "기본 개발 도구 설치"


    if(!$SkipGit){

        if(Get-Command git -ErrorAction SilentlyContinue){

            Write-Host "Git 이미 설치됨" -ForegroundColor Green

        }
        else {

            Write-Host "Git 설치"

            winget install `
            --id Git.Git `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements

        }

    }



    if(Get-Command node.exe -ErrorAction SilentlyContinue){

        Write-Host "Node.js 이미 설치됨" -ForegroundColor Green

    }
    else {


        Write-Host "Node.js 설치"


        winget install `
        --id OpenJS.NodeJS.LTS `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    }


    Refresh-Path



    if(Get-Command npm.cmd -ErrorAction SilentlyContinue){

        Write-Host "npm 설치 확인 완료" `
        -ForegroundColor Green

    }
    else {

        Write-Host "npm 확인 실패" `
        -ForegroundColor Yellow

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


    $choice =
    Read-Host "선택 (예: 1,2)"



    $selected=@()



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

        return Select-AITools

    }


    return $selected

}



function Install-Claude {


    Write-Step "Claude Code 설치"


    npm.cmd install --global `
    @anthropic-ai/claude-code


}



function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    npm.cmd install --global `
    @openai/codex


}



function Install-Gemini {


    Write-Step "Gemini CLI 설치"


    npm.cmd install --global `
    @google/gemini-cli


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

    Write-Host " $tool"

}


Write-Host ""
