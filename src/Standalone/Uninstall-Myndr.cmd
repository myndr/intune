@echo off

Echo "Start uninstall ==============================================="  >*>> C:\Users\Public\myndr_log.txt
powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command uninstall"  >> C:\Users\Public\myndr_log.txt

exit 0
