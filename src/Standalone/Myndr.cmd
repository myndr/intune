@echo off

SET ARG_command=install
SET ARG_level=machine
SET ARG_crc=0
set PARAM_0=0

:parameters_parse

set parameter=%~1
if "%parameter%"=="" goto parameters_parse_done
if "%parameter:~0,1%"=="-" (
    set ARG_%parameter:~1%="%~2"
    shift
    shift
    goto parameters_parse
)

set /a PARAM_0=%PARAM_0%+1
set PARAM_%PARAM_0%="%~1"
shift

goto parameters_parse

:parameters_parse_done



if "%ARG_command%"=="install" (
	Echo "Start install ==============================================="  >*>> C:\Users\Public\myndr_log.txt
	powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command install -crc %ARG_crc% -level %ARG_level%"  >> C:\Users\Public\myndr_log.txt
) Else If "%ARG_command%"=="uninstall" (
	Echo "Start uninstall ==============================================="  >*>> C:\Users\Public\myndr_log.txt
	powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command uninstall"  >> C:\Users\Public\myndr_log.txt
) Else (
	Echo "No actionable command  ========================================"  >*>> C:\Users\Public\myndr_log.txt
)


exit 0

