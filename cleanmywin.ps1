# Author: Julio P.
# Version: 0.1
# Date: 23.03.2024

# Check if the operating system is Windows 10
if ([System.Environment]::OSVersion.Version.Major -lt 10) {
    Write-Host "This script requires Windows 10."
    exit
}

# List of packages to check and uninstall
$packages = @(
    "Microsoft.WindowsCamera_8wekyb3d8bbwe",
    "Microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
    "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe",
    "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
    "Microsoft.Wallet_8wekyb3d8bbwe",
    "Microsoft.People_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
    "Microsoft.YourPhone_8wekyb3d8bbwe",
    "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
    "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
    "Microsoft.Office.OneNote_8wekyb3d8bbwe",
    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
    "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
    "Microsoft.Microsoft3DViewer_8wekyb3d8bbwe",
    "Microsoft.Getstarted_8wekyb3d8bbwe",
    "Microsoft.GetHelp_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
    "Microsoft.OneDrive"
)

# List of services to check and potentially disable
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

# Function to check if a package is installed
function IsPackageInstalled($packageName) {
    $result = winget list --id $packageName | Select-String -Pattern $packageName
    return $result.Length -gt 0
}

# Function to uninstall a package
function UninstallPackage($packageName) {
    winget rm --id $packageName --purge
}

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

# Check and uninstall each package
foreach ($package in $packages) {
    if (IsPackageInstalled($package)) {
        Write-Host "$package is installed. Uninstalling..."
        UninstallPackage($package)
        Write-Host "$package uninstalled successfully."
    }
}

# Check and potentially disable each service
foreach ($service in $services) {
    if (IsServiceEnabled($service)) {
        DisableService($service)
    }
}