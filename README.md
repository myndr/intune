# Myndr intune package `.intunewin`

## Preparation
Download and extract `IntuneWinAppUtile.exe` from https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool/ on a winbox.  
Copy the executable to `C:\Windows\system32`

# Packaging
Open an elevated command prompt on the winbox and type:
```
IntuneWinAppUtil.exe
```
The executable will reply with a couple of questions:  
`Please specify the source folder:` type the path to the package you want to create, e.g. `D:\src\Basispoort`  
`Please specify the setup file:` - `Install-Myndr.cmd`  
`Please specify the output folder:` - `D:\build\ `  
`Do you want to specify catalog folder (Y/N)?` - `n`  

The package will be successfully created when the output says:  
`INFO   Done!!!`

The package will be at:  
`D:\build\Install-Myndr.intunewin`

Refer to the `INSTRUCT.md` files in each variant folder for information on installing through Intune.
