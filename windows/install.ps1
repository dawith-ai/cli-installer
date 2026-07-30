#requires -Version 5.1

[CmdletBinding()]

param(

    [switch]$SkipPython,

    [switch]$SkipGit,

    [switch]$NoPrompt

)


$ErrorActionPreference = "Continue"



# ======================================
# 실행 정책 설정
# ======================================

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



# ======================================
# 공통 함수
# ======================================


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



    $extraPaths = @(

        "C:\Program Files\nodejs",

        "$env:APPDATA\npm"

    )



    foreach($path in $extraPaths) {


        if(
            (Test-Path $path) -and
            ($env:Path -notlike "*$path*")
        ){

            $env:Path += ";$path"

        }

    }

}



# ======================================
# 기본 개발환경 설치
# ======================================


function Install-BaseTools {


    Write-Step "기본 개발 도구 설치"



    if(!(Get-Command winget -ErrorAction SilentlyContinue)){


        Write-Host ""
        Write-Host "winget을 찾을 수 없습니다." `
            -ForegroundColor Red


        Write-Host `
        "Windows App Installer를 설치한 후 다시 실행하세요."


        exit 1

    }



    # Git

    if(!$SkipGit){


        if(Get-Command git -ErrorAction SilentlyContinue){


            Write-Host "Git 이미 설치됨" `
                -ForegroundColor Green


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



    # Node.js


    if(Get-Command node.exe -ErrorAction SilentlyContinue){


        Write-Host "Node.js 이미 설치됨" `
            -ForegroundColor Green


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



    Write-Host ""


    if(Get-Command node.exe -ErrorAction SilentlyContinue){


        Write-Host "Node 설치 확인 완료" `
            -ForegroundColor Green

    }



    if(Get-Command npm.cmd -ErrorAction SilentlyContinue){


        Write-Host "npm 설치 확인 완료" `
            -ForegroundColor Green

    }
    else {


        Write-Host "npm 확인 실패" `
            -ForegroundColor Yellow

    }

}




# ======================================
# AI CLI 선택
# ======================================


function Select-AITools {


    Write-Host ""

    Write-Host `
    "설치할 AI CLI를 선택하세요." `
    -ForegroundColor Cyan


    Write-Host ""

    Write-Host "[1] Claude Code"

    Write-Host "[2] OpenAI Codex"

    Write-Host "[3] Gemini CLI"

    Write-Host "[4] 전체 설치"


    Write-Host ""


    $choice =
    Read-Host "선택 (예: 1,2)"



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


        Write-Host ""
        Write-Host "잘못된 선택입니다. 다시 입력하세요." `
            -ForegroundColor Yellow


        return Select-AITools

    }



    return $selected

}





# ======================================
# AI CLI 설치
# ======================================


function Install-Claude {


    Write-Step "Claude Code 설치"


    Refresh-Path



    if(Get-Command claude -ErrorAction SilentlyContinue){


        Write-Host `
        "Claude Code 이미 설치됨" `
        -ForegroundColor Green


        return

    }



    npm.cmd install --global `
        @anthropic-ai/claude-code

}




function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    Refresh-Path



    if(Get-Command codex -ErrorAction SilentlyContinue){


        Write-Host `
        "Codex 이미 설치됨" `
        -ForegroundColor Green


        return

    }



    npm.cmd install --global `
        @openai/codex

}





function Install-Gemini {


    Write-Step "Gemini CLI 설치"


    Refresh-Path



    if(Get-Command gemini -ErrorAction SilentlyContinue){


        Write-Host `
        "Gemini CLI 이미 설치됨" `
        -ForegroundColor Green


        return

    }



    npm.cmd install --global `
        @google/gemini-cli

}





# ======================================
# 실행
# ======================================


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

Write-Host "============================="
Write-Host "설치 완료!" `
    -ForegroundColor Green
Write-Host "============================="



Write-Host ""

Write-Host "설치된 AI CLI:" `
    -ForegroundColor Cyan



foreach($tool in $selected){


    Write-Host " - $tool"

}



Write-Host ""

Write-Host "새 PowerShell 창을 열고 아래 명령어로 실행하세요."

Write-Host ""


foreach($tool in $selected){


    Write-Host $tool

}


Write-Host ""
