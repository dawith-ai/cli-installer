[CmdletBinding()]
param(
  [ValidateSet('Essential','All','Custom')][string]$Profile = 'Essential',
  [string[]]$Tools = @(), [switch]$SkipPython, [switch]$SkipGit, [switch]$NoPrompt
)

$ErrorActionPreference = 'Stop'
function Has-Command { param([string]$Name) return [bool](Get-Command $Name -ErrorAction SilentlyContinue) }
function Refresh-Path {
  $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  $user = [Environment]::GetEnvironmentVariable('Path', 'User')
  $env:Path = "$machine;$user"
}
function Install-Winget {
  param([string]$Id, [string]$Name, [string]$Command)
  if (Has-Command $Command) { Write-Host "Skip: $Name already installed." -ForegroundColor DarkYellow; return }
  Write-Host "Installing $Name..." -ForegroundColor Cyan
  & winget install --id $Id --exact --accept-package-agreements --accept-source-agreements --disable-interactivity
  if ($LASTEXITCODE -ne 0) { throw "$Name installation failed. (winget exit code: $LASTEXITCODE)" }
  Refresh-Path
  Write-Host "OK: $Name installed." -ForegroundColor Green
}
function Install-Npm {
  param([string]$Package, [string]$Name, [string]$Command)
  if (Has-Command $Command) { Write-Host "Skip: $Name already installed." -ForegroundColor DarkYellow; return }
  Write-Host "Installing $Name..." -ForegroundColor Cyan
  & npm install --global $Package
  if ($LASTEXITCODE -ne 0) { throw "$Name installation failed. (npm exit code: $LASTEXITCODE)" }
  Refresh-Path
  Write-Host "OK: $Name installed." -ForegroundColor Green
}

if (-not (Has-Command 'winget')) { throw "winget is required. Install App Installer from Microsoft Store, then try again." }
Write-Host '=== OneShot AI Developer Setup ===' -ForegroundColor Magenta
Install-Winget 'OpenJS.NodeJS.LTS' 'Node.js (LTS)' 'node'
if (-not $SkipPython) { Install-Winget 'Python.Python.3.13' 'Python' 'python' }
if (-not $SkipGit) { Install-Winget 'Git.Git' 'Git for Windows' 'git' }
Install-Winget 'Microsoft.VisualStudioCode' 'Visual Studio Code' 'code'

if ($Profile -eq 'Essential') { $selected = @('claude','codex') }
elseif ($Profile -eq 'All') { $selected = @('claude','codex','gemini') }
elseif ($Tools.Count -gt 0) { $selected = $Tools }
elseif ($NoPrompt) { throw 'Custom profile needs -Tools claude,codex.' }
else { $selected = (Read-Host 'Tools to install (claude, codex, gemini)').Split(',').Trim() }

foreach ($tool in $selected) {
  switch ($tool.ToLowerInvariant()) {
    'claude' { Install-Npm '@anthropic-ai/claude-code' 'Claude Code' 'claude' }
    'codex' { Install-Npm '@openai/codex' 'OpenAI Codex' 'codex' }
    'gemini' { Install-Npm '@google/gemini-cli' 'Gemini CLI' 'gemini' }
    default { throw "Unsupported tool: $tool. Use claude, codex, or gemini." }
  }
}
Write-Host 'Done. Start a project, then run: codex or claude' -ForegroundColor Green
