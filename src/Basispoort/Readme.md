# Install the Myndr Intune package
Take the following steps to install the Myndr Add-on for Edge and Myndr Extension for Chrome in the right user groups:

_The install procedure removes all previously installed Myndr extensions._

1. [Build](https://github.com/myndr/intune/tree/main) or [download](https://github.com/myndr/intune/releases) the Intune package for Basispoort.
2. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the package you just built or downloaded and click "OK"
4. Type `Myndr` in the **Publisher** field and click "Next"
5. Type `Myndr.cmd install` in the **Install command** * field
7. Type `Myndr.cmd uninstall` in the **Uninstall command** * field
8. Select "No" for **Allow available uninstall**
9. Keep **Install behavior** at "System"
10. Select "No specific action" for **Device restart behavior**
11. Click "Next"
12. Select the applicable architectures that are used by the user group
13. Select the applicable minimum OS and click "Next"
14. Select "Manually configured detection rules" and click "Add"
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionSettings\ighhbagifpldogkegacgffbneljjaoif` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK"
18. Click "Add" again
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionSettings\hmgiofkfdfmocnbdlaieodfpmlpockka` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK" and click "Next"
18. Click "Next" at **Dependencies**, "Next" at **Supercedence**
19. Assign the device group and click "Next"
20. Review and click "Create"

To speed up propagation, force synchronization as follows:
21. Click "Devices" and "All devices"
22. Click "Bulk actions for device"
23. Select "Windows", "Physical devices" and "Synchronization"
24. Click "Next" and review the devices you want to sync
25. Click "Next" and "Create" 

Within a couple of hours all users in the assigned student group should have the Myndr for Basispoort Add-on for Edge and Myndr Extension for Chrome installed.

