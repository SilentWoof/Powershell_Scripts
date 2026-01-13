@echo off
setlocal enabledelayedexpansion

:: --- Configuration Variables ---
set "REPO_URL=https://github.com/SilentWoof/Powershell_Scripts.git"
set "REPO_NAME=Powershell_Scripts"
set "REPO_DIR=D:\GitHub\%REPO_NAME%"
set "FALLBACK_DIR=C:\Users\%USERNAME%\GitHub\%REPO_NAME%"
set "PS_SCRIPT=Network_Drive_Mappings\network_drive_mappings.ps1"

:: --- Check if Git is installed ---
where git >nul 2>&1
if errorlevel 1 (
    echo Error: Git is not installed. Please install Git before proceeding.
    pause
    exit /b
)

echo Checking for repository on D drive...
if exist "%REPO_DIR%\.git" (
    echo Found repository on D drive.
    set "TARGET_DIR=%REPO_DIR%"
    cd /d "%TARGET_DIR%"
    echo [DEBUG] TARGET_DIR=%TARGET_DIR%
    cd
    echo Updating repository...
    git pull
    if errorlevel 1 (
        echo Warning: Failed to update the repository on D drive.
        echo Continuing without deleting anything.
    )
) else (
    echo Repository on D drive not found.
    goto check_c_drive
)

goto run_script

:check_c_drive
echo Checking for repository on C drive...
if exist "%FALLBACK_DIR%\.git" (
    echo Found repository on C drive.
    set "TARGET_DIR=%FALLBACK_DIR%"
    cd /d "%TARGET_DIR%"
    echo [DEBUG] TARGET_DIR=%TARGET_DIR%
    cd
    echo Updating repository...
    git pull
    if errorlevel 1 (
        echo Warning: Failed to update the repository on C drive.
        echo Continuing without deleting anything.
    )
) else (
    echo Repository not found on C drive either.
    goto clone_repo
)

goto run_script

:clone_repo
echo Cloning repository from %REPO_URL%...

if exist D: (
    set "TARGET_DIR=%REPO_DIR%"
) else (
    set "TARGET_DIR=%FALLBACK_DIR%"
)

git clone "%REPO_URL%" "%TARGET_DIR%"
if errorlevel 1 (
    echo Error: Failed to clone repository.
    pause
    exit /b
)

:run_script
echo Running PowerShell script: %PS_SCRIPT%

if not exist "%TARGET_DIR%\%PS_SCRIPT%" (
    echo Error: PowerShell script not found at %TARGET_DIR%\%PS_SCRIPT%
    pause
    exit /b
)

powershell -ExecutionPolicy Bypass -File "%TARGET_DIR%\%PS_SCRIPT%"