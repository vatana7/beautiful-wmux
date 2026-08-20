#Requires -Version 5.1
[CmdletBinding()]
param([switch]$Force)

$ErrorActionPreference = 'Stop'

function Test-WmuxInstalled {
    $exe = Join-Path $env:LOCALAPPDATA 'wmux\wmux.exe'
    $cmd = Join-Path $env:LOCALAPPDATA 'wmux\bin\wmux.cmd'
    return (Test-Path $exe) -or (Test-Path $cmd)
}

if ((Test-WmuxInstalled) -and -not $Force) {
    Write-Host "wmux already installed. Skip."
    return
}

$winget = Get-Command winget -ErrorAction SilentlyContinue
if ($winget) {
    Write-Host "Installing wmux via winget (openwong2kim.wmux)..."
    winget install --id openwong2kim.wmux -e --accept-package-agreements --accept-source-agreements
    if (Test-WmuxInstalled) {
        Write-Host "wmux installed."
        return
    }
    Write-Host "winget finished but wmux was not found. Trying Setup.exe fallback..." -ForegroundColor Yellow
}

$temp = Join-Path $env:TEMP 'wmux-setup.exe'
$uri = 'https://github.com/openwong2kim/wmux/releases/latest/download/wmux-3.44.0.Setup.exe'
try {
    $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/openwong2kim/wmux/releases/latest'
    $asset = $release.assets | Where-Object { $_.name -like '*.Setup.exe' } | Select-Object -First 1
    if ($asset) { $uri = $asset.browser_download_url }
} catch {
    Write-Host "Could not resolve latest release. Using known Setup.exe URL." -ForegroundColor Yellow
}

Write-Host "Downloading $uri"
Invoke-WebRequest -Uri $uri -OutFile $temp -UseBasicParsing
Write-Host "Running installer..."
Start-Process -FilePath $temp -Wait

if (-not (Test-WmuxInstalled)) {
    throw "wmux install finished but wmux.exe was not found under LocalAppData\wmux."
}

Write-Host "wmux installed."
