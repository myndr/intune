
# Building
We supply ready built Intune Win packages for your convenience but you can also build them yourself.  
To build the IntuneWin package yourself, take the following steps:

### Preparation
Download and extract the official `IntuneWinAppUtil.exe` by Microsoft from https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool/ on a Windows machine.  
Copy the executable to `C:\Windows\system32`

### Packaging
Open an elevated command prompt and type:
```
IntuneWinAppUtil.exe
```
The executable will reply with a couple of questions:  
`Please specify the source folder:` type the path to the package you want to create, `D:\src\Basispoort`, `D:\src\Standalone` or `D:\src\Remove`  
`Please specify the setup file:` - `Myndr.cmd`  or `Remove-Myndr.cmd`  
`Please specify the output folder:` - `D:\build\ `    
`Do you want to specify catalog folder (Y/N)?` - `n`   

The package will be successfully created when the output says:  
`INFO   Done!!!`  

Your package will be at:  
`D:\build`

