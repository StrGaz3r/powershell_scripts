# Written and Developed by Bryce Levi Evans Email: evansb76@gmail.com
# This Script is designed to operate in Windows Normal Booted Environment with "Elevated" privileges aka run as Admin.
# Script 1 of 2; For proper automated policy.xml edit Please run this script first
# ---------------------------------------------------------------------------------------------------------


$autoLoginUser = "User"  # Replace with specific Local Admin Account
$autoLoginPassword = "password"  # Replace with the password for the Local Admin Account
$autoLoginDomain = "."  # Use "." for localhost accounts only 

Write-Output "Adding EditPolicy_SafeMode registry key..."

# Add the RunOnce registry key for EditPolicy_SafeMode (this will run once after reboot) edit "YourDirectory" to match the directory containing EditPolicy_safeMode.ps1
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "*EditAmpPolicy" -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File C:\YourDirectory\EditPolicy_SafeMode.ps1"

Write-Output "EditPolicy_SafeMode registry key added."

# Set up the registry for Auto-Login (this will run once and log in automatically)
$autoLoginRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $autoLoginRegPath -Name "AutoAdminLogon" -Value "1"
Set-ItemProperty -Path $autoLoginRegPath -Name "DefaultUsername" -Value $autoLoginUser
Set-ItemProperty -Path $autoLoginRegPath -Name "DefaultPassword" -Value $autoLoginPassword
Set-ItemProperty -Path $autoLoginRegPath -Name "DefaultDomainName" -Value $autoLoginDomain
Write-Output "Auto-Login configured for user $autoLoginUser."

# Set Safe Mode with Networking
Write-Output "Setting boot mode to Safe Mode with Networking..."

# Run bcdedit as administrator using cmd
Start-Process cmd.exe -ArgumentList "/c bcdedit /set {current} safeboot network" -Verb RunAs

# Reboot the system after a delay
Write-Output "Rebooting in 5 seconds..."
Start-Sleep -Seconds 5
shutdown /r /t 5
