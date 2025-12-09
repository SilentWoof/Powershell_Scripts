@echo off
setlocal

:: First try D:\Github
set "scriptPath=D:\Github\Powershell_Scripts\Unifi_Drive_Mappings\drive_mappings.ps1"
if not exist "%scriptPath%" (
    :: If not found, try under the current user's profile
    set "scriptPath=%USERPROFILE%\Github\Powershell_Scripts\Unifi_Drive_Mappings\drive_mappings.ps1"
)

:: Run with elevated PowerShell
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%scriptPath%\"' -Verb RunAs"

endlocal