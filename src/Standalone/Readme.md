# Install the Myndr Intune package
Take the following steps to install the Myndr Add-on for Edge and Myndr Extension for Chrome in the right device groups:

_The install procedure removes all previously installed Myndr extensions._

1. [Build](https://github.com/myndr/intune/tree/main) or [download](https://github.com/myndr/intune/releases) the Standalone Intune package.
2. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the **Install-Myndr.intunewin** package and click "OK"
4. Type `Myndr` in the **Publisher** field and click "Next"
5. Type `Install-Myndr.cmd <classroom-code> ` in the **Install command** field
6. Replace `<classroom-code>` with the Myndr classroom code for the current user group e.g. `Install-Myndr.cmd 1234`
7. Type `Uninstall-Myndr.cmd` in the **Uninstall command** * field
8. Select "No" for **Allow available uninstall**
9. Select "User" for **Install behavior**
10. Select "No specific action" for **Device restart behavior**
11. Click "Next"
12. Select the applicable architectures that are used by the user group
13. Select the applicable minimum OS and click "Next"
14. Select "Manually configured detection rules" and click "Add"
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionSettings\gefgignjfgonchhgoinfdgbioakdlmkj` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK"
18. Click "Add" again
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionSettings\bgoljgoooefjbaeojjfefbabkhcnhojg` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK" and click "Next"
18. Click "Next" at **Dependencies**, "Next" at **Supercedence**
19. Assign the group that should be associated with the classroom code from step 5 and click "Next"
20. Review and click "Create"

To speed up propagation, force synchronization as follows:

1. Click "Devices" and "All devices"
2. Click "Bulk actions for device"
3. Select "Windows", "Physical devices" and "Synchronization"
4. Click "Next" and review the devices you want to sync
5. Click "Next" and "Create"

Within a couple of hours all users in the assigned group should have the Myndr Add-on for Edge and Myndr Extension for Chrome installed. 