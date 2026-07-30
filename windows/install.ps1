[CmdletBinding()]
param(
    [ValidateSet('Essential', 'All', 'Custom')]
    [string]$Profile = 'Essential',
    [string[]]$Tools = @(),
    [switch]$SkipPython,
    [switch]$SkipGit,
    [switch]$NoPrompt,
    [string]$SourceBase
)

function Import-OneShotFile {
    param([string]$RelativePath)
    if ($PSScriptRoot) {
        . (Join-Path $PSScriptRoot $RelativePath)
        return
    }
    if (-not $SourceBase) { throw '원격 설치에 필요한 SourceBase 주소가 없습니다.' }
    . ([scriptblock]::Create((Invoke-RestMethod -Uri "$SourceBase/windows/$RelativePath" -ErrorAction Stop)))
}

Import-OneShotFile 'modules/core.ps1'
Import-OneShotFile 'modules/packages.ps1'
Import-OneShotFile 'providers/claude.ps1'
Import-OneShotFile 'providers/codex.ps1'
Import-OneShotFile 'providers/gemini.ps1'

function Get-SelectedTools {
    if ($Profile -eq 'Essential') { return @('claude', 'codex') }
    if ($Profile -eq 'All') { return @('claude', 'codex', 'gemini') }
    if ($Tools.Count -gt 0) { return $Tools.ForEach({ $_.ToLowerInvariant() }) }
    if ($NoPrompt) { throw 'Custom 프로필에는 -Tools claude,codex 처럼 설치할 도구를 지정해야 합니다.' }

    Write-Host "`n설치할 AI 도구를 쉼표로 입력하세요. (claude, codex, gemini)" -ForegroundColor Yellow
    $answer = Read-Host '예: claude,codex'
    if ([string]::IsNullOrWhiteSpace($answer)) { throw '선택한 도구가 없습니다.' }
    return @($answer.Split(',').Trim().ForEach({ $_.ToLowerInvariant() }) | Where-Object { $_ })
}

Write-Host "`n=== OneShot AI 개발환경 설치기 ===" -ForegroundColor Magenta
Write-Host "프로필: $Profile  |  설치는 이미 있는 도구를 건너뜁니다.`n" -ForegroundColor DarkGray

$selected = @(Get-SelectedTools)
$installers = @{
    claude = { Install-ClaudeCode }
    codex  = { Install-Codex }
    gemini = { Install-GeminiCli }
}
$unknown = @($selected | Where-Object { -not $installers.ContainsKey($_) })
if ($unknown) { throw "지원하지 않는 도구: $($unknown -join ', '). 지원값: claude, codex, gemini" }

$step = 1
$total = 1 + $selected.Count
Write-Step $step $total '기본 개발 도구 설치'
Install-BaseTools -InstallPython (-not $SkipPython) -InstallGit (-not $SkipGit)
$step++

foreach ($tool in $selected) {
    Write-Step $step $total "$(($tool.Substring(0,1).ToUpper() + $tool.Substring(1))) 설치"
    & $installers[$tool]
    $step++
}

Write-Host "`n완료되었습니다. 새 프로젝트 폴더에서 아래처럼 시작하세요." -ForegroundColor Green
if ($selected -contains 'claude') { Write-Host '  claude' }
if ($selected -contains 'codex')  { Write-Host '  codex' }
if ($selected -contains 'gemini') { Write-Host '  gemini' }
Write-Host "`n로그인이 필요한 도구는 처음 실행할 때 브라우저에서 로그인 안내가 열립니다." -ForegroundColor DarkGray
