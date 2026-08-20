# Cursor Agent on PATH (also in User PATH)
$agentBin = Join-Path $env:LOCALAPPDATA 'cursor-agent'
if (Test-Path $agentBin) {
    if ($env:Path -notlike "*$agentBin*") {
        $env:Path = "$agentBin;$env:Path"
    }
}

# Colorful Oh My Posh prompt (Catppuccin Mocha)
$ompConfig = Join-Path $HOME '.posh-catppuccin-mocha.omp.json'
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    if (Test-Path $ompConfig) {
        oh-my-posh init powershell --config $ompConfig | Invoke-Expression
    } else {
        oh-my-posh init powershell | Invoke-Expression
    }
}

# Colored file icons in directory listings
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# Colorful command-line editing (works on Windows PowerShell 5.1)
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue
    Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
    Set-PSReadLineOption -Colors @{
        Command            = 'Cyan'
        Parameter          = 'DarkCyan'
        String             = 'Green'
        Operator           = 'DarkYellow'
        Variable           = 'Magenta'
        Number             = 'Yellow'
        Type               = 'DarkCyan'
        Comment            = 'DarkGray'
        Keyword            = 'Blue'
        Member             = 'White'
        ContinuationPrompt = 'DarkGray'
        Default            = 'White'
        Error              = 'Red'
        Selection          = 'DarkGray'
    } -ErrorAction SilentlyContinue
}

function ll { Get-ChildItem -Force }

# Quick aliases for Cursor Agent
Set-Alias -Name ag -Value agent -ErrorAction SilentlyContinue
Set-Alias -Name ca -Value cursor-agent -ErrorAction SilentlyContinue
