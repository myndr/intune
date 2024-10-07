@echo off


SET AI_CRC=%1
SET args=

:: First is either allowInactive or crc
IF "%AI_CRC%"=="0" (
    REM Do not allow Inactive
    SET inact=0
) ELSE IF "%AI_CRC%"=="1" (
    REM Allow Inactive
    SET inact=1
) ELSE (
    REM Set crc in argument
    SET args=-crc %1
    REM (Do not allow Inactive)
    SET inact=0
)

:: Second is level
if [%2]==[] (
    REM Default MACHINE level
    SET level=machine
) else (
    REM Set level to argument
    SET level=%2
)

Echo "Start install ==============================================="  >*>> C:\Users\Public\myndr_log.txt
powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command install %args% -allowinactive %inact% -level %level%"  >> C:\Users\Public\myndr_log.txt

exit 0

