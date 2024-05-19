## allow script execution:
## Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser 
## or
## Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 
. .\helpers.ps1
Test-Admin
Install-Choco

## to install:
$programs = @(
    @{ Name = "Visual Studio Code"; ChocoName = "vscode"; FileName = "Code.exe" },
    @{ Name = "Obsidian"; ChocoName = "obsidian"; FileName = "Obsidian.exe" },
    @{ Name = "Discord"; ChocoName = "discord"; FileName = "Discord.exe" },
    @{ Name = "Google Chrome"; ChocoName = "googlechrome"; FileName = "chrome.exe" },
    @{ Name = "Mozilla Firefox"; ChocoName = "firefox"; FileName = "firefox.exe" },
    @{ Name = "7-Zip"; ChocoName = "7zip"; FileName = "7zFM.exe" },
    @{ Name = "PowerToys"; ChocoName = "powertoys"; FileName = "PowerToys.exe" },
    @{ Name = "Windows Terminal"; ChocoName = "microsoft-windows-terminal"; FileName = "wt.exe" },
    @{ Name = "Steam"; ChocoName = "steam"; FileName = "Steam.exe" },
    @{ Name = "Docker Desktop"; ChocoName = "docker-desktop"; FileName = "Docker Desktop.exe" }
)

## install, if not already installed :3
foreach ($program in $programs) {
    if (-not (Find-Program -fileName $program.FileName)) {
        Write-Output "Installing $($program.Name)..."
        try {
            choco install $program.ChocoName -y
        } catch {
            Write-Error "Error during installation of this fcker $($program.Name): $_"
        }
    }
    else {
        Write-Output "$($program.Name) is already installed."
    }
}
