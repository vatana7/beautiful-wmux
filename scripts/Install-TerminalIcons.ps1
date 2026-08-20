#Requires -Version 5.1
[CmdletBinding()]
param([switch]$Force)

$ErrorActionPreference = 'Stop'

$existing = Get-Module -ListAvailable Terminal-Icons | Select-Object -First 1
if ($existing -and -not $Force) {
    Write-Host "Terminal-Icons already installed ($($existing.Version)). Skip."
    return
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$nuget = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
if (-not $nuget -or [version]$nuget.Version -lt [version]'2.8.5.201') {
    Write-Host "Installing NuGet package provider..."
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser | Out-Null
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force -AllowClobber

$mod = Get-Module -ListAvailable Terminal-Icons | Select-Object -First 1
if (-not $mod) { throw "Terminal-Icons install failed." }
Write-Host "Terminal-Icons $($mod.Version) ready."
