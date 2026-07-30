#requires -Version 5.1


$ErrorActionPreference = "Stop"


function Write-Step {

    param(
        [string]$Message
    )

    Write-Host ""
    Write-Host "== $Message ==" -ForegroundColor Cyan
}



function Install-BaseTools {

    Write-Step "기본 개발 도구 설치"


    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {

        Write-Host "winget이 없습니다. Windows App Installer를 설치해주세요."
        exit 1

    }


    Write-Host "Git 설치"

    winget install `
        --id Git.Git `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements



    Write-Host "Node.js 설치"

    winget install `
        --id OpenJS.NodeJS.LTS `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

}




function Install-ClaudeCode {


    Write-Step "Claude Code 설치"


    if (!(Get-Command npm -ErrorAction SilentlyContinue)) {

        Write-Host "npm이 없습니다. Node.js 설치 후 다시 실행하세요."
        return

    }


    npm install -g @anthropic-ai/claude-code

}




function Install-Codex {


    Write-Step "OpenAI Codex 설치"


    if (!(Get-Command npm -ErrorAction SilentlyContinue)) {

        Write-Host "npm이 없습니다."
        return

    }


    npm install -g @openai/codex

}




Write-Step "OneShot AI 개발환경 시작"


Install-BaseTools


Install-ClaudeCode


Install-Codex


Write-Host ""
Write-Host "모든 설치 완료" -ForegroundColor Green
