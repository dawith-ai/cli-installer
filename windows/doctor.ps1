[CmdletBinding()]
param()

$checks = @(
    @{ Name = 'Node.js'; Command = 'node'; Version = @('--version') },
    @{ Name = 'Python'; Command = 'python'; Version = @('--version') },
    @{ Name = 'Git'; Command = 'git'; Version = @('--version') },
    @{ Name = 'VS Code'; Command = 'code'; Version = @('--version') },
    @{ Name = 'Claude Code'; Command = 'claude'; Version = @('--version') },
    @{ Name = 'OpenAI Codex'; Command = 'codex'; Version = @('--version') },
    @{ Name = 'Gemini CLI'; Command = 'gemini'; Version = @('--version') }
)

Write-Host "`n=== OneShot 환경 점검 ===" -ForegroundColor Cyan
foreach ($check in $checks) {
    $command = Get-Command $check.Command -ErrorAction SilentlyContinue
    if ($command) {
        $version = (& $check.Command @($check.Version) 2>$null | Select-Object -First 1)
        Write-Host "  OK   $($check.Name) $version" -ForegroundColor Green
    } else {
        Write-Host "  --   $($check.Name) 없음" -ForegroundColor DarkYellow
    }
}
