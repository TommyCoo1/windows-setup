
## admin check
function Test-Admin {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Need admin rights"
        exit
    }
}

## Install tasty Chocolatey :D
function Install-Choco {
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    } catch {
        Write-Error "Error installing tasty chocolatey: $_"
        exit
    }
}

## search in static Paths + Windows Registry
function Find-Program {
    param ([string]$fileName)
    # static paths
    $paths = Get-PSDrive -PSProvider FileSystem | ForEach-Object { $_.Root + "Program Files\", $_.Root + "Program Files (x86)\" }
    foreach ($path in $paths) {
        if (Get-ChildItem $path -Recurse -Filter $fileName -ErrorAction SilentlyContinue) {
            return $true
        }
    }
    # Windows Registry
    $regPaths = @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\", "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\")
    foreach ($regPath in $regPaths) {
        $items = Get-ItemProperty "$regPath*" -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*$fileName*" }
        if ($items -and $items.InstallLocation -and (Test-Path $items.InstallLocation)) {
            return $true
        }
    }
    return $false
}