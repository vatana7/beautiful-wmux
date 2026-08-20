#Requires -Version 5.1
[CmdletBinding()]
param([switch]$Force)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing
$installed = New-Object System.Drawing.Text.InstalledFontCollection
$hasFont = $installed.Families | Where-Object { $_.Name -eq 'CaskaydiaCove NF' }

if ($hasFont -and -not $Force) {
    Write-Host "CaskaydiaCove NF already installed. Skip."
    return
}

$zip = Join-Path $env:TEMP 'CascadiaCode-NF.zip'
$dest = Join-Path $env:TEMP 'CascadiaCodeNF'
$uri = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip'

Write-Host "Downloading CascadiaCode Nerd Font..."
Invoke-WebRequest -Uri $uri -OutFile $zip -UseBasicParsing

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Expand-Archive -Path $zip -DestinationPath $dest -Force

$fontDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
New-Item -ItemType Directory -Force -Path $fontDir | Out-Null
$regPath = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'

$files = Get-ChildItem $dest -Recurse -Filter 'CaskaydiaCoveNerdFont-*.ttf'
if (-not $files) {
    throw "No CaskaydiaCoveNerdFont-*.ttf files found in the download."
}

foreach ($file in $files) {
    $target = Join-Path $fontDir $file.Name
    Copy-Item $file.FullName $target -Force
    $fontName = "$($file.BaseName) (TrueType)"
    New-ItemProperty -Path $regPath -Name $fontName -Value $target -PropertyType String -Force | Out-Null
    Write-Host "Installed $($file.Name)"
}

Write-Host "CaskaydiaCove NF font files registered. Restart apps if the font list is stale."
