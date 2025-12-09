@echo off
setlocal

:: Repo details
set "repoUrl=https://github.com/SilentWoof/Powershell_Scripts.git"
set "repoName=Powershell_Scripts"
set "subDir=Network_Drive_Mappings"
set "scriptFile=network_drive_mappings.ps1"

:: Candidate base paths
set "primaryBase=D:\Github"
set "secondaryBase=%USERPROFILE%\Github"

:: Candidate full paths
set "primaryPath=%primaryBase%\%repoName%\%subDir%\%scriptFile%"
set "secondaryPath=%secondaryBase%\%repoName%\%subDir%\%scriptFile%"

:: Function-like block to ensure repo exists and is synced
:EnsureRepo
if exist "%~1\%repoName%" (
    echo Repo found at %~1\%repoName%. Syncing...
    pushd "%~1\%repoName%"
    git status >nul 2>&1
    if %errorlevel%==0 (
        git pull
    ) else (
        echo [WARNING] Repo at %~1\%repoName% not valid. Re-cloning...
        rmdir /s /q "%~1\%repoName%"
        git clone "%repoUrl%" "%~1\%repoName%"
    )
    popd
) else (
    echo Repo not found at %~1. Cloning fresh copy...
    git clone "%repoUrl%" "%~1\%repoName%"
)
goto :eof

:: --- Priority order ---
:: 1. Check D:\Github
if exist "%primaryBase%" (
    if exist "%primaryBase%\%repoName%" (
        call :EnsureRepo "%primaryBase%"
    ) else (
        echo Repo not present on D:\. Will check C:\ next...
    )
)

:: 2. If not found/synced on D, check C:\Users\<user>\Github
if not exist "%primaryPath%" (
    if exist "%secondaryBase%" (
        if exist "%secondaryBase%\%repoName%" (
            call :EnsureRepo "%secondaryBase%"
        ) else (
            echo Repo not present on C:\Users. Will clone fresh...
        )
    )
)

:: 3. Clone fresh if neither exists
if not exist "%primaryPath%" if not exist "%secondaryPath%" (
    if exist "%primaryBase%" (
        echo Cloning repo to D:\Github...
        git clone "%repoUrl%" "%primaryBase%\%repoName%"
    ) else (
        echo Cloning repo to %secondaryBase%...
        git clone "%repoUrl%" "%secondaryBase%\%repoName%"
    )
)

:: --- Select script path ---
if exist "%primaryPath%" (
    set "scriptPath=%primaryPath%"
) else if exist "%secondaryPath%" (
    set "scriptPath=%secondaryPath%"
) else (
    echo [ERROR] Could not obtain %scriptFile% from GitHub repo.
    pause
    exit /b 1
)

:: Run with elevated PowerShell
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%scriptPath%\"' -Verb RunAs"

endlocal