# Function to check if the script is running as an administrator
function Test-Admin {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
 
# Function to restart the script with administrative privileges
function Start-Admin {
    $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process PowerShell -ArgumentList $argList -Verb RunAs
    exit
}
 
# If not running as administrator, restart as administrator
if (-not (Test-Admin)) {
    Start-Admin
}
 
# Define the base path where Cisco AMP is installed
$basePath = "C:\Program Files\Cisco\AMP"
 
# Get all subdirectories in the base path
$directories = Get-ChildItem -Path $basePath -Directory
 
foreach ($directory in $directories) {
    # Construct the path to the uninstaller
    $uninstallPath = Join-Path -Path $directory.FullName -ChildPath "uninstall.exe"
    # Check if the uninstaller executable exists
    if (Test-Path $uninstallPath) {
        try {
            Write-Host "Attempting to uninstall Cisco AMP from version folder: $($directory.Name)"
            Start-Process -FilePath $uninstallPath -ArgumentList "/R", "/S", "/remove", "1" -Wait -NoNewWindow
            Write-Host "Uninstallation for version $($directory.Name) completed successfully."
        } catch {
            Write-Host "Failed to start uninstallation for version $($directory.Name). Error: $_"
        }
    } else {
        Write-Host "Uninstaller for version $($directory.Name) not found at path: $uninstallPath"
    }
}
 
Write-Host "Uninstallation script completed."