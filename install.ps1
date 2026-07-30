[CmdletBinding()]
param(
    [ValidateSet('Essential', 'All', 'Custom')]
    [string]$Profile = 'Essential',
    [string[]]$Tools = @(),
    [switch]$SkipPython,
    [switch]$SkipGit,
    [switch]$NoPrompt
)

# This small entry point keeps `irm .../install.ps1 | iex` working after the
# installer grows into multiple files. For local use it forwards to windows/install.ps1.
$repoRoot = $PSScriptRoot
if ($repoRoot -and (Test-Path (Join-Path $repoRoot 'windows/install.ps1'))) {
    & (Join-Path $repoRoot 'windows/install.ps1') @PSBoundParameters
    exit $LASTEXITCODE
}

$sourceBase = 'https://raw.githubusercontent.com/dawith-ai/cli-installer/main'
$main = Invoke-RestMethod -Uri "$sourceBase/windows/install.ps1" -ErrorAction Stop
& ([scriptblock]::Create($main)) -SourceBase $sourceBase @PSBoundParameters
