#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Root,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$themeSrc = Join-Path $Root 'config\catppuccin-mocha.omp.json'
$themeDst = Join-Path $HOME '.posh-catppuccin-mocha.omp.json'

$omp = Get-Command oh-my-posh -ErrorAction SilentlyContinue
if (-not $omp) {
    Write-Host "Installing Oh My Posh via winget..."
    winget install --id JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    throw "oh-my-posh is still missing after install. Open a new shell and re-run."
}

if ((Test-Path $themeDst) -and -not $Force) {
    Write-Host "Oh My Posh theme already present. Skip copy."
} else {
    Copy-Item -Path $themeSrc -Destination $themeDst -Force
    Write-Host "Wrote $themeDst"
}

Write-Host "Oh My Posh ready: $(oh-my-posh version)"
