@echo off
setlocal enabledelayedexpansion

:: --- Configuration Variables ---
set "REPO_URL=https://github.com/SilentWoof/Powershell_Scripts.git"
set "REPO_NAME=Powershell_Scripts"
set "REPO_DIR=D:\Github\%REPO_NAME%"
set "FALLBACK_DIR=C:\Users\%USERNAME%\Github\%REPO_NAME%"
set "PS_SCRIPT=Network_Drive_Mappings\network_drive_mappings.ps1"

:: --- Check if Git is installed ---
where git >nul 2>&1
if errorlevel 1 (
    echo Error: Git is not installed. Please install Git before proceeding.
    pause
    exit /b
)

echo [DEBUG] REPO_URL=%REPO_URL%

:: --- Step 1: Check for the repository on the D drive ---
echo Checking for repository on D drive...
if exist "%REPO_DIR%\.git" (
    echo Found repository on D drive.
    set "TARGET_DIR=%REPO_DIR%"
    cd /d "%TARGET_DIR%"
    echo Updating repository...
    git pull
    if errorlevel 1 (
        echo Error: Failed to update the repository on D drive.
        if exist "%REPO_DIR%" rd /s /q "%REPO_DIR%"
        set "TARGET_DIR=%REPO_DIR%"
        goto clone_repo
    )
) else (
    echo Repository on D drive does not exist or is not a valid Git repository.
    if exist "%REPO_DIR%" rd /s /q "%REPO_DIR%"
    goto check_c_drive
)

:check_c_drive
echo Checking for repository on C drive...
if exist "%FALLBACK_DIR%\.git" (
    echo Found repository on C drive.
    set "TARGET_DIR=%FALLBACK_DIR%"
    cd /d "%TARGET_DIR%"
    echo Updating repository...
    git pull
    if errorlevel 1 (
        echo Error: Failed to update the repository on C drive.
        if exist "%FALLBACK_DIR%" rd /s /q "%FALLBACK_DIR%"
        set "TARGET_DIR=%FALLBACK_DIR%"
        goto clone_repo
    )
) else (
    echo Repository on C drive does not exist or is not a valid Git repository.
    if exist "%FALLBACK_DIR%" rd /s /q "%FALLBACK_DIR%"
    :: Do not set TARGET_DIR here — let clone_repo decide
    goto clone_repo
)

:clone_repo
echo Cloning repository from %REPO_URL%...

:: Decide where to clone if TARGET_DIR is not already set
if "%TARGET_DIR%"=="" (
    if exist D: (
        set "TARGET_DIR=%REPO_DIR%"
    ) else (
        set "TARGET_DIR=%FALLBACK_DIR%"
    )
)

echo [DEBUG] Final TARGET_DIR=%TARGET_DIR%
git clone "%REPO_URL%" "%TARGET_DIR%"
if errorlevel 1 (
    if "%TARGET_DIR%"=="%REPO_DIR%" (
        echo Error: Failed to clone to D drive. Trying C drive...
        set "TARGET_DIR=%FALLBACK_DIR%"
        echo [DEBUG] TARGET_DIR=%TARGET_DIR%
        git clone "%REPO_URL%" "%TARGET_DIR%"
        if errorlevel 1 (
            echo Error: Failed to clone to C drive.
            pause
            exit /b
        )
    ) else (
        echo Error: Failed to clone to C drive.
        pause
        exit /b
    )
)

echo Running PowerShell script: %PS_SCRIPT%
if not exist "%TARGET_DIR%\%PS_SCRIPT%" (
    echo Error: PowerShell script not found at %TARGET_DIR%\%PS_SCRIPT%
    pause
    exit /b
)

powershell -ExecutionPolicy Bypass -File "%TARGET_DIR%\%PS_SCRIPT%"
