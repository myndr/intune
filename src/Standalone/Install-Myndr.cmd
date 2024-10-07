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

:: Second is distractions
if [%2]==[] (
    REM Do not allow distractions
    SET dist=0
) else (
    REM Allow distractions
    SET dist=%2
)

Echo "Start install ==============================================="  >*>> C:\Users\Public\myndr_log.txt
powershell.exe -ExecutionPolicy Bypass -command "& '.\Myndr.ps1' -command install %args% -allowinactive %inact% -distractions %dist%"  >> C:\Users\Public\myndr_log.txt

exit 0

