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


    $extraPaths = @(
        "C:\Program Files\nodejs",
        "$env:APPDATA\npm"
    )


    foreach ($path in $extraPaths) {

        if ((Test-Path $path) -and ($env:Path -notlike "*$path*")) {

            $env:Path += ";$path"

        }
    }
}



function Install-BaseTools {


    Write-Step "기본 개발 도구 설치"


    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {

        Write-Host "winget을 찾을 수 없습니다." -ForegroundColor Red
        exit 1

    }


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



    Write-Host "환경 변수 갱신"


    Refresh-Path



    if (Get-Command node.exe -ErrorAction SilentlyContinue) {

        Write-Host "Node 설치 확인 완료" -ForegroundColor Green

    }
    else {

        Write-Host "Node를 찾지 못했습니다." -ForegroundColor Yellow

    }



    if (Get-Command npm.cmd -ErrorAction SilentlyContinue) {

        Write-Host "npm 설치 확인 완료" -ForegroundColor Green

    }
    else {

        Write-Host "npm을 찾지 못했습니다." -ForegroundColor Yellow

    }

}



function Install-ClaudeCode {


    Write-Step "Claude Code 설치"


    Refresh-Path


    if (!(Get-Command npm.cmd -ErrorAction SilentlyContinue)) {

        Write-Host "npm이 없습니다. Node.js 설치 후 다시 실행하세요." -ForegroundColor Yellow

        return $false

    }



    npm.cmd install --global @anthropic-ai/claude-code



    Refresh-Path



    if (Get-Command claude -ErrorAction SilentlyContinue) {

        Write-Host "Claude Code 설치 완료" -ForegroundColor Green

        return $true

    }


    Write-Host "Claude Code 설치 확인 실패" -ForegroundColor Yellow

    return $false

}



function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    Refresh-Path


    if (!(Get-Command npm.cmd -ErrorAction SilentlyContinue)) {

        Write-Host "npm이 없습니다." -ForegroundColor Yellow

        return $false

    }



    npm.cmd install --global @openai/codex



    Refresh-Path



    if (Get-Command codex -ErrorAction SilentlyContinue) {

        Write-Host "Codex 설치 완료" -ForegroundColor Green

        return $true

    }


    Write-Host "Codex 설치 확인 실패" -ForegroundColor Yellow

    return $false

}




# ==========================
# 설치 시작
# ==========================


Write-Step "OneShot AI 개발환경 시작"



$results = @()



Install-BaseTools



$results += Install-ClaudeCode

$results += Install-Codex



Write-Host ""



if ($results -contains $false) {


    Write-Host "일부 도구 설치가 완료되지 않았습니다." -ForegroundColor Yellow

    Write-Host ""
    Write-Host "새 PowerShell 창을 열고 다시 실행해보세요."

}
else {


    Write-Host "모든 설치 완료!" -ForegroundColor Green

}



Write-Host ""

Write-Host "사용 가능한 명령어:"
Write-Host "  claude"
Write-Host "  codex"
