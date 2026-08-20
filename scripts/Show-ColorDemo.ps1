#Requires -Version 5.1
<#
.SYNOPSIS
  Colorful terminal demo for beautiful-wmux screenshots (Windows PowerShell 5.1 safe).
#>
[CmdletBinding()]
param()

$Esc = [char]27

function Write-Rgb {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][int]$R,
        [Parameter(Mandatory = $true)][int]$G,
        [Parameter(Mandatory = $true)][int]$B,
        [switch]$NoNewline
    )
    $out = "$Esc[38;2;${R};${G};${B}m$Text$Esc[0m"
    if ($NoNewline) {
        [Console]::Write($out)
    } else {
        [Console]::WriteLine($out)
    }
}

function Write-BgRgb {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][int]$R,
        [Parameter(Mandatory = $true)][int]$G,
        [Parameter(Mandatory = $true)][int]$B,
        [switch]$NoNewline
    )
    $out = "$Esc[48;2;${R};${G};${B}m$Text$Esc[0m"
    if ($NoNewline) {
        [Console]::Write($out)
    } else {
        [Console]::WriteLine($out)
    }
}

function Write-GradientText {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [int]$R1, [int]$G1, [int]$B1,
        [int]$R2, [int]$G2, [int]$B2
    )
    $n = [Math]::Max($Text.Length - 1, 1)
    for ($i = 0; $i -lt $Text.Length; $i++) {
        $t = $i / $n
        $r = [int]($R1 + ($R2 - $R1) * $t)
        $g = [int]($G1 + ($G2 - $G1) * $t)
        $b = [int]($B1 + ($B2 - $B1) * $t)
        Write-Rgb -Text $Text[$i] -R $r -G $g -B $b -NoNewline
    }
    [Console]::WriteLine()
}

Clear-Host
[Console]::WriteLine()

$banner = @(
    '  ____  _____    _    _   _ _____ ___ _____ _   _ _',
    ' | __ )| ____|  / \  | | | |_   _|_ _|  ___| | | | |',
    ' |  _ \|  _|   / _ \ | | | | | |  | || |_  | | | | |',
    ' | |_) | |___ / ___ \| |_| | | |  | ||  _| | |_| | |___',
    ' |____/|_____/_/   \_\\___/  |_| |___|_|    \___/|_____|',
    '              W M U X   D E S K   S E T U P'
)

$lineColors = @(
    @(203, 166, 247),
    @(245, 194, 231),
    @(137, 180, 250),
    @(148, 226, 213),
    @(166, 227, 161),
    @(249, 226, 175)
)

for ($i = 0; $i -lt $banner.Length; $i++) {
    $c = $lineColors[$i % $lineColors.Count]
    Write-Rgb -Text $banner[$i] -R $c[0] -G $c[1] -B $c[2]
}

[Console]::WriteLine()
Write-GradientText -Text '  Catppuccin Mocha  |  CaskaydiaCove NF  |  Oh My Posh  |  Terminal-Icons' `
    -R1 137 -G1 180 -B1 250 -R2 245 -G2 194 -B2 231
[Console]::WriteLine()

[Console]::Write('  palette  ')
$swatches = @(
    @(30, 30, 46),
    @(69, 71, 90),
    @(205, 214, 244),
    @(243, 139, 168),
    @(250, 179, 135),
    @(249, 226, 175),
    @(166, 227, 161),
    @(148, 226, 213),
    @(137, 180, 250),
    @(180, 190, 254),
    @(203, 166, 247),
    @(245, 194, 231)
)
foreach ($s in $swatches) {
    Write-BgRgb -Text '    ' -R $s[0] -G $s[1] -B $s[2] -NoNewline
}
[Console]::WriteLine()

[Console]::Write('           ')
$labels = @('base', 'surf', 'text', 'red ', 'pech', 'yel ', 'grn ', 'teal', 'blu ', 'lav ', 'mau ', 'pnk ')
for ($i = 0; $i -lt $swatches.Count; $i++) {
    $s = $swatches[$i]
    Write-Rgb -Text $labels[$i] -R $s[0] -G $s[1] -B $s[2] -NoNewline
}
[Console]::WriteLine()
[Console]::WriteLine()

# Rainbow bar
[Console]::Write('  ')
$bar = '################################################################'
for ($i = 0; $i -lt $bar.Length; $i++) {
    $hue = 360.0 * $i / $bar.Length
    $h = ($hue % 360) / 60.0
    $x = 1 - [Math]::Abs(($h % 2) - 1)
    switch ([int][Math]::Floor($h)) {
        0 { $rr = 1; $gg = $x; $bb = 0 }
        1 { $rr = $x; $gg = 1; $bb = 0 }
        2 { $rr = 0; $gg = 1; $bb = $x }
        3 { $rr = 0; $gg = $x; $bb = 1 }
        4 { $rr = $x; $gg = 0; $bb = 1 }
        default { $rr = 1; $gg = 0; $bb = $x }
    }
    Write-BgRgb -Text ' ' -R ([int]($rr * 255)) -G ([int]($gg * 255)) -B ([int]($bb * 255)) -NoNewline
}
[Console]::WriteLine()
[Console]::WriteLine()

# Fake "neofetch" style card
Write-Rgb -Text '  host ...... prometheus@vatana' -R 137 -G 180 -B 250
Write-Rgb -Text '  shell ..... Windows PowerShell 5.1' -R 148 -G 226 -B 213
Write-Rgb -Text '  theme ..... Catppuccin Mocha' -R 203 -G 166 -B 247
Write-Rgb -Text '  font ...... CaskaydiaCove NF' -R 245 -G 194 -B 231
Write-Rgb -Text '  prompt .... Oh My Posh' -R 249 -G 226 -B 175
Write-Rgb -Text '  icons ..... Terminal-Icons' -R 166 -G 227 -B 161
[Console]::WriteLine()

$repo = Resolve-Path (Join-Path $PSScriptRoot '..')
Write-Rgb -Text ("  repo ...... {0}" -f $repo.Path) -R 180 -G 190 -B 254
[Console]::WriteLine()

if (Get-Module -ListAvailable Terminal-Icons) {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

Get-ChildItem $repo.Path |
    Sort-Object { -not $_.PSIsContainer }, Name |
    Format-Table Mode, LastWriteTime, Name -AutoSize

[Console]::WriteLine()
Write-Rgb -Text '  colors look good? ship it.' -R 166 -G 227 -B 161
[Console]::WriteLine()
