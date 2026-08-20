#Requires -Version 5.1
<#
.SYNOPSIS
  Main bootstrap for beautiful-wmux desk setup.
.PARAMETER Force
  Overwrite configs even when setup already looks complete.
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$Root = $PSScriptRoot

function Write-Step([string]$Message) {
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

Write-Host "beautiful-wmux bootstrap" -ForegroundColor Magenta
Write-Host "Root: $Root"
if ($Force) { Write-Host "Mode: Force" -ForegroundColor Yellow }

Write-Step "Install wmux"
& (Join-Path $Root 'scripts\Install-Wmux.ps1') -Force:$Force

Write-Step "Install Oh My Posh + theme"
& (Join-Path $Root 'scripts\Install-OhMyPosh.ps1') -Root $Root -Force:$Force

Write-Step "Install Terminal-Icons"
& (Join-Path $Root 'scripts\Install-TerminalIcons.ps1') -Force:$Force

Write-Step "Write PowerShell profile"
& (Join-Path $Root 'scripts\Set-PowerShellProfile.ps1') -Root $Root -Force:$Force

Write-Step "Install CaskaydiaCove NF"
& (Join-Path $Root 'scripts\Install-NerdFont.ps1') -Force:$Force

Write-Step "Apply wmux Catppuccin theme + font"
& (Join-Path $Root 'scripts\Set-WmuxTheme.ps1') -Force:$Force

Write-Host ""
Write-Host "Done. Open a new wmux pane to load the colorful prompt." -ForegroundColor Green
Write-Host "If you still see empty boxes, set font to CaskaydiaCove NF in wmux Settings." -ForegroundColor DarkGray
