# Written and Developed by Bryce Levi Evans Email: evansb76@gmail.com
# This Script is designed to operate in Windows Safe Mode
# Script 2 of 2; For proper automated policy.xml edit please run Powershell Script: SetSafeMode_RunOnce.ps1
# ---------------------------------------------------------------------------------------------------------
# Remove Auto-Login registry entries
Write-Output "Removing Auto-Login registry entries..."

$autoLoginRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
if (Test-Path $autoLoginRegPath) {
    Remove-ItemProperty -Path $autoLoginRegPath -Name "AutoAdminLogon" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $autoLoginRegPath -Name "DefaultUsername" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $autoLoginRegPath -Name "DefaultPassword" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $autoLoginRegPath -Name "DefaultDomainName" -ErrorAction SilentlyContinue
    Write-Output "Auto-Login registry entries removed."
} else {
    Write-Output "Auto-Login registry path not found. No entries to remove."
}

# Define paths and files
$policyFile = "C:\Program Files\Cisco\AMP\policy.xml"

Write-Output "Attempting to modify policy.xml..."

# Modify the policy.xml if it exists
if (Test-Path $policyFile) {
    try {
        # Take ownership and grant full access permissions
        takeown /f $policyFile | Out-Null
        icacls $policyFile /grant administrators:F | Out-Null

        # Load the XML file
        [xml]$xml = Get-Content $policyFile

        # Clear the passwordex element without worrying about namespace (since policy.xml is simple enough)
        $passwordexElement = $xml.Signature.Object.config.agent.control.passwordex
		if ($passwordexElement) {
			# Clear the value by setting it directly (because it behaves like a string)
			$xml.Signature.Object.config.agent.control.passwordex = ""
			$xml.Save($policyFile)
			Write-Output "Password field cleared in policy.xml"
		} else {
			Write-Output "<passwordex> element not found within <Control> in policy.xml"
}

    }
    catch {
        Write-Output "Failed to edit policy.xml: $_"
    }
} else {
    Write-Output "policy.xml not found at $policyFile"
}

# Reset boot mode and initiate shutdown
Write-Output "Resetting boot mode to normal..."

Start-Process cmd.exe -ArgumentList "/c bcdedit /deletevalue {current} safeboot" -Verb RunAs

Write-Output "Rebooting in 5 seconds..."
Start-Sleep -Seconds 5
shutdown /r /t 5
