@echo off
setlocal

:: Define candidate paths
set "primaryPath=D:\Github\Powershell_Scripts\Network_Drive_Mappings\network_drive_mappings.ps1"
set "secondaryPath=%USERPROFILE%\Github\Powershell_Scripts\Network_Drive_Mappings\network_drive_mappings.ps1"

:: Pick whichever exists
if exist "%primaryPath%" (
    set "scriptPath=%primaryPath%"
) else if exist "%secondaryPath%" (
    set "scriptPath=%secondaryPath%"
) else (
    echo [ERROR] Could not find network_drive_mappings.ps1 in any known location.
    pause
    exit /b 1
)

:: Run with elevated PowerShell
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%scriptPath%\"' -Verb RunAs"

endlocal
