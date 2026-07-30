Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Step {
    param([int]$Number, [int]$Total, [string]$Message)
    Write-Host "`n[$Number/$Total] $Message" -ForegroundColor Cyan
}

function Write-Success { param([string]$Message) Write-Host "  OK  $Message" -ForegroundColor Green }
function Write-Skip { param([string]$Message) Write-Host "  Skip  $Message" -ForegroundColor DarkYellow }
function Write-InstallerWarning { param([string]$Message) Write-Host "  Warning  $Message" -ForegroundColor Yellow }

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

function Test-Command { param([string]$Name) return [bool](Get-Command $Name -ErrorAction SilentlyContinue) }

function Assert-Winget {
    if (-not (Test-Command 'winget')) {
        throw "winget을 찾을 수 없습니다. Microsoft Store에서 'App Installer'를 설치한 뒤 다시 실행하세요."
    }
}

function Install-WingetPackage {
    param([string]$Id, [string]$Name, [string]$Command)
    if (Test-Command $Command) { Write-Skip "$Name 은(는) 이미 설치되어 있습니다."; return }
    Write-Host "  $Name 설치 중..." -ForegroundColor Gray
    & winget install --id $Id --exact --accept-package-agreements --accept-source-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) { throw "$Name 설치에 실패했습니다. (winget exit code: $LASTEXITCODE)" }
    Refresh-Path
    Write-Success "$Name 설치 완료"
}

function Install-NpmPackage {
    param([string]$Package, [string]$Name, [string]$Command)
    if (Test-Command $Command) { Write-Skip "$Name 은(는) 이미 설치되어 있습니다."; return }
    if (-not (Test-Command 'npm')) { throw "$Name 설치 전에 Node.js/npm이 필요합니다." }
    Write-Host "  $Name 설치 중..." -ForegroundColor Gray
    & npm install --global $Package
    if ($LASTEXITCODE -ne 0) { throw "$Name 설치에 실패했습니다. (npm exit code: $LASTEXITCODE)" }
    Refresh-Path
    Write-Success "$Name 설치 완료"
}
