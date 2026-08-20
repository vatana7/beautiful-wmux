#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Root,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$template = Join-Path $Root 'config\Microsoft.PowerShell_profile.ps1'
if (-not (Test-Path $template)) {
    throw "Missing profile template: $template"
}

$targets = @(
    (Join-Path $HOME 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'),
    (Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1')
)

foreach ($profilePath in $targets) {
    $dir = Split-Path $profilePath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    if ((Test-Path $profilePath) -and -not $Force) {
        $current = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($current -and $current -match 'oh-my-posh' -and $current -match 'posh-catppuccin-mocha') {
            Write-Host "Profile already configured: $profilePath"
            continue
        }
        $backup = "$profilePath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $profilePath $backup -Force
        Write-Host "Backed up existing profile to $backup"
    }

    Copy-Item -Path $template -Destination $profilePath -Force
    Write-Host "Wrote $profilePath"
}
