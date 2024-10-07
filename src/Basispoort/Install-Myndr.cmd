@echo off

Echo "Start install ==============================================="  >*>> C:\Users\Public\myndr_log.txt
powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command install"  >> C:\Users\Public\myndr_log.txt

exit 0
