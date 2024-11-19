# Myndr intune package `.intunewin`

## Installing
You can install Myndr via Intune for different environment set-ups:
1. **Basispoort** - use this if your school uses Basispoort for student SSO.
2. **Stand-alone Machine level** - use this if your school _doesn't use Basispoort_ and the students have their "own" designated device.
3. **Stand-alone User level** - use this if your school _doesn't use Basispoort_ and the students DO NOT have ~~their "own" designated device~~.


_Each of the install procedures attempts to remove all previously installed Myndr extensions._

## Basispoort
Take the following steps to install the Myndr Add-on for Edge and Myndr Extension for Chrome in the right device groups:

1. Download the latest [Intune package for Basispoort](https://github.com/myndr/intune/releases) from the releases page.
2. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the package you just built or downloaded and click "OK"
4. Type `Myndr` in the **Publisher** field and click "Next"
5. Type `Myndr.cmd` in the **Install command** * field
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

## Stand-alone

In case your school does not use Basispoort for student SSO, we offer a means to install Myndr either on machine or on user level.
In both cases you need to supply the Myndr classroom code during the install procedure.

### 2. Stand-alone Machine level
Take the following steps to install the Myndr Add-on for Edge and Myndr Extension for Chrome in the right device groups:

1. Download the latest [Standalone Intune package](https://github.com/myndr/intune/releases).
2. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the **Install-Myndr.intunewin** package and click "OK"
4. Type `Myndr` in the **Publisher** field and click "Next"
5. Type `Myndr.cmd -crc <classroom-code> ` in the **Install command** field
6. Replace `<classroom-code>` with the Myndr classroom code for the current user group e.g. `Myndr.cmd -crc 1234`
7. Type `Myndr.cmd -command uninstall` in the **Uninstall command** * field
8. Select "No" for **Allow available uninstall**
9. Select "User" for **Install behavior**
10. Select "No specific action" for **Device restart behavior**
11. Click "Next"
12. Select the applicable architectures that are used by the user group
13. Select the applicable minimum OS and click "Next"
14. Select "Manually configured detection rules" and click "Add"
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionSettings\ioagfbkdbiaocmlmhepflbbjmalpdgod` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK"
18. Click "Add" again
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionSettings\afphljjmbndfchfkdpegkckkcbejepik` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK" and click "Next"
18. Click "Next" at **Dependencies**, "Next" at **Supercedence**
19. Assign the group that should be associated with the classroom code from step 5 and click "Next"
20. Review and click "Create"

### 3. Stand-alone User level

Take the following steps to install the Myndr Add-on for Edge and Myndr Extension for Chrome in the right user groups:

1. [Build](h##-building) or [download](https://github.com/myndr/intune/releases) the Standalone Intune package.
2. Open [Intune](https://intune.microsoft.com/) and go to Apps > All apps.
2. Click "➕ Add", select app type **Windows app (Win32)**, click "Select"
3. Click "Select app package file", click "Select a file", select the **Install-Myndr.intunewin** package and click "OK"
4. Type `Myndr` in the **Publisher** field and click "Next"
5. Type `Myndr.cmd -crc <classroom-code> -level user` in the **Install command** field
6. Replace `<classroom-code>` with the Myndr classroom code for the current user group e.g. `Myndr.cmd -crc 1234 -level user`
8. Type `Myndr.cmd -command uninstall` in the **Uninstall command** * field
8. Select "No" for **Allow available uninstall**
9. Select "User" for **Install behavior**
10. Select "No specific action" for **Device restart behavior**
11. Click "Next"
12. Select the applicable architectures that are used by the user group
13. Select the applicable minimum OS and click "Next"
14. Select "Manually configured detection rules" and click "Add"
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\ExtensionSettings\ioagfbkdbiaocmlmhepflbbjmalpdgod` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK"
18. Click "Add" again
15. Select "Registry" as **Rule type**
16. Copy: `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionSettings\afphljjmbndfchfkdpegkckkcbejepik` and paste it in the **Key path** field
17. Select "Key exists" as **Detection method**, click "OK" and click "Next"
18. Click "Next" at **Dependencies**, "Next" at **Supercedence**
19. Assign the group that should be associated with the classroom code from step 5 and click "Next"
20. Review and click "Create"

### Synchronization
To speed up propagation, force synchronization as follows:
21. Click "Devices" and "All devices"
22. Click "Bulk actions for device"
23. Select "Windows", "Physical devices" and "Synchronization"
24. Click "Next" and review the devices you want to sync
25. Click "Next" and "Create"

Within a couple of hours all users or devices in the assigned user or device group should have the Myndr Add-on for Edge and Myndr Extension for Chrome installed.


## Building
To build the IntuneWin package yourself, take the following steps:


### Preparation
Download and extract the official `IntuneWinAppUtile.exe` by Microsoft from https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool/ on a Windows machine.  
Copy the executable to `C:\Windows\system32`

### Packaging
Open an elevated command prompt and type:
```
IntuneWinAppUtil.exe
```
The executable will reply with a couple of questions:  
`Please specify the source folder:` type the path to the package you want to create, e.g. `D:\src\Basispoort`  
`Please specify the setup file:` - `Myndr.cmd`  
`Please specify the output folder:` - `D:\build\ `  
`Do you want to specify catalog folder (Y/N)?` - `n`  

The package will be successfully created when the output says:  
`INFO   Done!!!`

The package will be at:  
`D:\build\Myndr.intunewin`
