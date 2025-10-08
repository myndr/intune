# Remove Myndr extensions
When you previously used either an IntuneWin app or Powershell script to install the Myndr extension on your organisations devices but you're unable to remove them, use this IntuneWin app to clean the registry from any previously set keys, thereby instructing the browsers to uninstall the extension.

## Installing the removal tool

Take the following steps to install the removal tool in the right device groups:

1. Download the latest [Removal tool](https://github.com/myndr/intune/releases) (`Remove-Myndr.intunewin`).
2. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the `Remove-Myndr.intunewin` package and click "OK"
4. Type `Myndr` in the **Publisher** field and click "Next"
5. Type `Remove-Myndr.cmd` in the **Install command** field
7. Type `Remove-Myndr.cmd -command uninstall` in the **Uninstall command** * field
10. Select "Intune will force a mandatory device restart" for **Device restart behavior**
11. Click "Next"
12. Leave the **Check operating system architecture** option set to "No..."
13. Select the applicable minimum OS and click "Next"
14. Select "Manually configured detection rules" and click "Add"
15. Select "File" as **Rule type**
16. Copy: `C:\Users\Public` and paste it in the **Path** field
16. Copy: `remove_myndr_log.txt` and paste it in the **File or folder** field
17. Select "File or folder exists" as **Detection method**
18. Switch **Associated with a 32-bit app on 64-bit clients** to yes and click "OK"
18. Click "Next"
18. Click "Next" at **Dependencies**, "Next" at **Supercedence**
19. Assign the group that should be associated with the classroom code from step 5 and click "Next"
20. Review and click "Create"

### Synchronization
To speed up propagation, force synchronization as follows:  
1. Click "Devices" and "All devices"
2. Click "Bulk actions for device"
3. Select "Windows", "Physical devices" and "Synchronization"
4. Click "Next" and review the devices you want to sync
5. Click "Next" and "Create"

Within a couple of hours all users or devices in the assigned user or device group should have the Myndr Add-on for Edge and Myndr Extension for Chrome removed.

You can leave the app or, if you're certain all devices are cleaned, remove it from Intune.
