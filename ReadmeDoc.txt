----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The provided scripts were designed for organizations or users who have lost the password to their Cisco Endpoint Detection Collectors and no longer have access to the Cisco EDR Management Portal.
Recomended Use:
Run Manually with a "Elevated" Powershell Console or AD GPO Creating Task that runs as NT AUTHORITY\System ***ONE TIME***
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**Simple Summary of the Two Scripts' Goal**

The two PowerShell scripts work together to safely change a setting in a Cisco AMP security file by:

1. **First Script (SetSafeMode_RunOnce.ps1):**
   - Prepares the computer to restart in **Safe Mode with Networking**.
   - Sets up an automatic login so the computer can reboot and run the second script without needing a password.
   - Adds a task to automatically run the second script after reboot.

2. **Second Script (EditPolicy_SafeMode.ps1):**
   - Runs in Safe Mode after reboot.
   - Removes the automatic login settings to make the computer secure again.
   - Finds and clears a password field inside a special file (`policy.xml`) used by Cisco AMP.
   - Changes the computer back to **Normal Mode**.
   - Restarts the computer.

**In short:**
The two scripts automate a safe way to edit a protected file by temporarily setting the computer to Safe Mode, making the change, and then putting everything back to normal — all with minimal user involvement.


**Summary of Script - SetSafeMode_RunOnce.ps1**

**Goal:**
This script helps set up a computer so it restarts into "Safe Mode with Networking" and automatically logs into a specific user account. It also makes sure another small script runs once when the computer turns back on.

**What Happens Step-by-Step:**

1. **Setting the Login Information:**
   - The script saves the username, password, and computer name for the account that should automatically log in.

2. **Getting Another Script Ready to Run:**
   - It adds a note inside the computer's system settings to run a different script called `EditPolicy_SafeMode.ps1` after the restart.
   - You need to make sure the location of this other script is correct.

3. **Setting Up Auto-Login:**
   - The script tells the computer to automatically log in using the account information given.

4. **Changing How the Computer Starts:**
   - It changes the computer settings so that next time it starts, it will go into "Safe Mode with Networking." (Safe Mode is a special way to start the computer to fix problems.)

5. **Restarting the Computer:**
   - It waits for 5 seconds and then restarts the computer.

**Things to Remember:**
- **Password Safety:** The password is saved in a way that is not very secure, so be careful where and how you use this script.
- **Fix the File Location:** Make sure to update the script with the correct location of the `EditPolicy_SafeMode.ps1` file.
- **Administrator Rights Needed:** You must run this script as an administrator (someone with full control of the computer).
- **After Restart:** Once the computer restarts, it will log in by itself, run the other script, and be in "Safe Mode with Networking."

**End of Simple Summary**

**Summary of the Script - EditPolicy_SafeMode.ps1**

**Purpose:**
This script is made to run while the computer is in **Safe Mode**. It cleans up settings from a previous script and fixes a file used by Cisco AMP.

**Step-by-Step:**

1. **Remove Auto-Login Settings:**
   - Deletes saved login information from the computer’s system settings so it doesn't automatically log in anymore.

2. **Modify a Special File (policy.xml):**
   - Looks for a file called `policy.xml` used by Cisco AMP software.
   - If the file is found:
     - Takes control of the file.
     - Gives full access to administrators.
     - Clears out the password field inside the file so that it is empty.
   - If the file isn't found, it just shows a message.

3. **Reset the Computer’s Boot Settings:**
   - Changes the settings back to normal so the computer will no longer start in Safe Mode.

4. **Restart the Computer:**
   - Waits 5 seconds and then restarts the computer.

**Important Notes:**
- This script is the second part of a two-script process.
- You need to run the first script (`SetSafeMode_RunOnce.ps1`) before this one for everything to work correctly.
- It must be run with administrator rights.



