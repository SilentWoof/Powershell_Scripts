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

:: --- Check D drive repo ---
echo Checking for repository on D drive...
set "TARGET_DIR=%REPO_DIR%"
if exist "%TARGET_DIR%\.git" (
    echo Found repository on D drive.
    cd /d "%TARGET_DIR%"
    echo [DEBUG] TARGET_DIR=%TARGET_DIR%
    echo [DEBUG] CURRENT DIR:
    cd
    if not exist "%TARGET_DIR%\.git" (
        echo Error: .git folder not found in %TARGET_DIR%
        echo Skipping git pull.
    ) else (
        echo Updating repository...
        git pull
        if errorlevel 1 (
            echo Warning: Failed to update the repository on D drive.
            echo Continuing without deleting anything.
        )
    )
    goto run_script
)

:: --- Check C drive repo ---
echo Repository on D drive not found.
echo Checking for repository on C drive...
set "TARGET_DIR=%FALLBACK_DIR%"
if exist "%TARGET_DIR%\.git" (
    echo Found repository on C drive.
    cd /d "%TARGET_DIR%"
    echo [DEBUG] TARGET_DIR=%TARGET_DIR%
    echo [DEBUG] CURRENT DIR:
    cd
    if not exist "%TARGET_DIR%\.git" (
        echo Error: .git folder not found in %TARGET_DIR%
        echo Skipping git pull.
    ) else (
        echo Updating repository...
        git pull
        if errorlevel 1 (
            echo Warning: Failed to update the repository on C drive.
            echo Continuing without deleting anything.
        )
    )
    goto run_script
)

:: --- Clone repo if not found ---
echo Repository not found on C drive either.
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