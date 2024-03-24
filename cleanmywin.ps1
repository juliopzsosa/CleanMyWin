# Author: Julio P.
# Version: 0.2
# Date: 23.03.2024

# Check if the operating system is Windows 10 22H2 or later
$os = Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Version
$major, $minor, $build = $os -split '\.'
if (($major -lt 10) -and ($build -lt 19044)) {
    Write-Host "This script requires Windows 10 22H2 or later."
    exit
}

# List of services to disable
$services = @(
    "MixedRealityOpenXRSvc",
    "shpamsvc",
    "WbioSrvc",
    "wisvc",
    "WpcMonSvc",
    "XblAuthManager",
    "XblGameSave",
    "XboxGipSvc",
    "XboxNetApiSvc"
)

# List of packages to uninstall
$packagesToUninstall = @(
    "Microsoft.GetHelp_8wekyb3d8bbwe",
    "Microsoft.Getstarted_8wekyb3d8bbwe",
    "Microsoft.Microsoft3DViewer_8wekyb3d8bbwe",
    "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
    "Microsoft.Office.OneNote_8wekyb3d8bbwe",
    "Microsoft.People_8wekyb3d8bbwe",
    "Microsoft.Wallet_8wekyb3d8bbwe",
    "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
    "Microsoft.WindowsCamera_8wekyb3d8bbwe",
    "Microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
    "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
    "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
    "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe",
    "Microsoft.YourPhone_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
    "Microsoft.OneDrive"
)

# List of packages to install using Winget
$packagesToInstall = @(
    "7zip.7zip",
    "Bitwarden.Bitwarden",
    "dbeaver.dbeaver",
    "Discord.Discord",
    "DupeGuru.DupeGuru",
    "Figma.Figma",
    "flux.flux",
    "GIMP.GIMP",
    "Google.GoogleDrive",
    "Google.PlatformTools",
    "Google.QuickShare",
    "HDDGURU.HDDLLFTool",
    "Microsoft.PowerShell",
    "Microsoft.PowerToys",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "NGWIN.PicPick",
    "ONLYOFFICE.DesktopEditors",
    "Ookla.Speedtest.CLI",
    "VideoLAN.VLC",
    "WhatsApp.WhatsApp"
)

# Function to check if a service is enabled
function IsServiceEnabled($serviceName) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service -ne $null) {
        return $service.Status -eq "Running"
    }
    return $false
}

# Function to disable a service
function DisableService($serviceName) {
    if (IsServiceEnabled($serviceName)) {
        Write-Host "Disabling $serviceName..."
        Set-Service -Name $serviceName -StartupType Disabled
        Write-Host "$serviceName disabled successfully."
    }
}

# Check and disable each service
foreach ($service in $services) {
    if (IsServiceEnabled($service)) {
        Write-Host "Disabling $service."
        DisableService($service)
        Write-Host "$service was disabled successfully."
    } else {
        Write-Host "$service is already disabled."
    }
}

# Function to check if a package is installed
function IsPackageInstalled($packageName) {
    $result = winget list --id $packageName | Select-String -Pattern $packageName
    return $result.Length -gt 0
}

# Function to uninstall a package
function UninstallPackage($packageName) {
    winget rm --id $packageName --purge
}

# Check and uninstall each package
foreach ($package in $packagesToUninstall) {
    if (IsPackageInstalled($package)) {
        UninstallPackage($package)
    } else {
        Write-Host "$package is already uninstalled."
    }
}

# Function to install a package
function InstallPackage($packageName) {
    winget add --id $packageName --silent --disable-interactivity
}

# Check and install each package silently
foreach ($package in $packagesToInstall) {
    if (!(IsPackageInstalled($package))) {
        InstallPackage($package)
    } else {
        Write-Host "$package is already installed."
    }
}

Read-Host -Prompt "Press Enter to finish"