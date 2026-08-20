#Requires -Version 5.1
[CmdletBinding()]
param([switch]$Force)

$ErrorActionPreference = 'Stop'

$sessionPath = Join-Path $env:APPDATA 'wmux\session.json'
$wmuxExe = Join-Path $env:LOCALAPPDATA 'wmux\wmux.exe'
$desiredTheme = 'catppuccin'
$desiredFont = 'CaskaydiaCove NF'
$desiredSize = 15
$desiredCursor = 'bar'

function Get-WmuxProcesses {
    Get-Process -Name wmux -ErrorAction SilentlyContinue
}

function Read-Session {
    if (-not (Test-Path $sessionPath)) {
        throw "wmux session file not found: $sessionPath. Open wmux once, then re-run."
    }
    return (Get-Content $sessionPath -Raw | ConvertFrom-Json)
}

function Write-Session($json) {
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($sessionPath, ($json | ConvertTo-Json -Depth 40), $utf8NoBom)
}

function Test-Desired([object]$json) {
    return ($json.theme -eq $desiredTheme) -and
           ($json.terminalFontFamily -eq $desiredFont) -and
           ([int]$json.terminalFontSize -eq $desiredSize) -and
           ($json.terminalCursorStyle -eq $desiredCursor)
}

$json = $null
try { $json = Read-Session } catch { Write-Host $_.Exception.Message -ForegroundColor Yellow }

if ($json -and (Test-Desired $json) -and -not $Force) {
    Write-Host "wmux theme/font already set. Skip."
    return
}

$running = @(Get-WmuxProcesses)
if ($running.Count -gt 0) {
    Write-Host ""
    Write-Host "wmux is running. To apply theme/font, this script must quit wmux, patch session.json, then reopen wmux." -ForegroundColor Yellow
    $answer = Read-Host "Quit wmux now and apply? [Y/n]"
    if ($answer -and $answer -notmatch '^(Y|y|)$') {
        Write-Host "Skipped theme patch."
        Write-Host "Manual path: Settings → theme Catppuccin, font CaskaydiaCove NF."
        return
    }

    Write-Host "Closing wmux..."
    Get-WmuxProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    $deadline = (Get-Date).AddSeconds(20)
    while ((Get-WmuxProcesses) -and (Get-Date) -lt $deadline) {
        Start-Sleep -Milliseconds 500
    }
    if (Get-WmuxProcesses) {
        throw "wmux did not exit in time. Close it manually and re-run."
    }
}

$json = Read-Session
$json.theme = $desiredTheme
$json.terminalFontFamily = $desiredFont
$json.terminalFontSize = $desiredSize
$json.terminalCursorStyle = $desiredCursor
Write-Session $json
Write-Host "Patched $sessionPath"

if (Test-Path $wmuxExe) {
    Write-Host "Reopening wmux..."
    Start-Process -FilePath $wmuxExe
} else {
    Write-Host "wmux.exe not found at $wmuxExe. Start wmux yourself." -ForegroundColor Yellow
}

Write-Host "Theme=$desiredTheme Font=$desiredFont"
