. .\helpers.ps1
Test-Admin
Install-Choco

# Install Windows Terminal and oh-my-posh
 try {
    choco install microsoft-windows-terminal -y
    winget install JanDeDobbeleer.OhMyPosh
} catch {
    Write-Error "Error :c $_"
    exit
}

# Install + Font 
oh-my-posh font install 'JetBrainsMono'# Nerd Font'
$font = "JetBrainsMono NF"
New-Item -ItemType Directory -Force -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $settingsPath) {
    (Get-Content $settingsPath -Raw) -replace 'fontFace": "[^"]+"', 'fontFace": "' + $font + '"' | Set-Content $settingsPath
} else {
    Write-Warning "No Config file found :/"
}

# Create + Setup $PROFILE for PowerShell
New-Item -Path $PROFILE -Type File -Force 
"oh-my-posh init pwsh --config '$env:POSH_THEMES_PATH/easy-term.omp.json' | Invoke-Expression" | Out-File -Append $PROFILE

# Nice for terminal recommendations :o
Install-Module PSReadLine -Force
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Install WSL?
if (-not (wsl -l)) {
    wsl --install
} else {
    Write-Output "You already got WSL, dumb idiot."
}
