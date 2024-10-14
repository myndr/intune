@echo off

if [%1]==[] (
	SET command=install
) Else (
	SET command=%1
)

if "%command%"=="install" (
	Echo "Start install ================================================="  >*>> C:\Users\Public\myndr_log.txt
	powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command install"  >> C:\Users\Public\myndr_log.txt
) Else If "%command%"=="uninstall" (
	Echo "Start uninstall ==============================================="  >*>> C:\Users\Public\myndr_log.txt
	powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command uninstall"  >> C:\Users\Public\myndr_log.txt
) Else (
	Echo "No actionable command  ========================================"  >*>> C:\Users\Public\myndr_log.txt
)

exit 0
