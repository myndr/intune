@echo off

Echo "Start uninstall ==============================================="  >*>> C:\Users\Public\remove_myndr_log.txt
powershell.exe -ExecutionPolicy Bypass -command "& '.\Remove-Myndr.ps1'"  >> C:\Users\Public\remove_myndr_log.txt

exit 0