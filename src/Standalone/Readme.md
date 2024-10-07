# Install the Myndr IntuneWin package
Take the following steps to install the Myndr Add-on for Edge and Myndr Extension for Chrome in the right user groups:

1. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the downloaded **Install-Myndr.intunewin** and click "OK"
4. Type "_Myndr_" in the **Publisher** field and click "Next"
5. Type "_Install-Myndr.cmd_" in the **Install command** * field
6. Add the Myndr classroom code for the current user groep e.g. 1234: Type "_Install-Myndr.cmd 1234_" in the **Install command** * field
7. Type "_Uninstall-Myndr.cmd_" in the **Uninstall command** * field
8. Select "No" for **Allow available uninstall**
9. Select "User" for **Install behavior**
10. Select "No specific action" for **Device restart behavior**
11. Click "Next"
12. Select the applicable architectures that are used by the user group
13. Select the applicable minimum OS and click "Next"
14. Select "Manually configured detection rules" and click "Add"
15. Select "Registry" as **Rule type**
16. Type "HKEY_CURRENT_USER\SOFTWARE\Myndr" in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK" and click "Next"
18. Click "Next" at **Dependencies**, "Next" at **Supercedence**
19. Assign the group that should be associated with the classroom code from step 5 and click "Next"
20. Review and click "Create"

Within a couple of hours all users in the assigned group should have the Myndr Add-on for Edge and Myndr Extension for Chrome installed. 