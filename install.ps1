# ============================================================
# DKSH Commercial AI — Agent Skill Installer (Windows)
# Usage: irm https://raw.githubusercontent.com/Iamnote123/dksh-agents/main/install.ps1 | iex
# ============================================================

$RepoRaw    = "https://raw.githubusercontent.com/Iamnote123/dksh-agents/main"
$InstallDir = "$env:USERPROFILE\.claude\skills\dksh-commercial-ai"
$RefDir     = "$InstallDir\references"

$Agents = @("ORCHESTRATOR.md","FORECAST_PLANNER.md","ACCOUNT_STRATEGIST.md","PROMO_PLANNER.md","DATA_VALIDATOR.md")

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  DKSH Commercial AI — Agent Installer"     -ForegroundColor Cyan
Write-Host "  Energizer / Eveready / Carglo"            -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $RefDir     | Out-Null

$Fail = $false

Write-Host "-> Downloading agent files..." -ForegroundColor Yellow
Write-Host ""
foreach ($file in $Agents) {
    try {
        Invoke-WebRequest -Uri "$RepoRaw/$file" -OutFile "$InstallDir\$file" -ErrorAction Stop
        Write-Host "  OK  $file" -ForegroundColor Green
    } catch {
        Write-Host "  FAILED: $file" -ForegroundColor Red; $Fail = $true
    }
}

Write-Host ""
Write-Host "-> Downloading reference files..." -ForegroundColor Yellow
Write-Host ""
try {
    Invoke-WebRequest -Uri "$RepoRaw/references/context.md" -OutFile "$RefDir\context.md" -ErrorAction Stop
    Write-Host "  OK  references/context.md" -ForegroundColor Green
} catch {
    Write-Host "  FAILED: references/context.md" -ForegroundColor Red; $Fail = $true
}

Write-Host ""
if (-not $Fail) {
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "  Install complete!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Location: $InstallDir" -ForegroundColor Cyan
    Write-Host "  Next: Add ORCHESTRATOR.md to Claude Project instructions" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "FAILED — Check repo is Public." -ForegroundColor Red; exit 1
}
