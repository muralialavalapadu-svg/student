@echo off
setlocal enabledelayedexpansion
title Push Student Performance to GitHub

echo ========================================================
echo   Student Performance & Prediction - Push to GitHub
echo ========================================================
echo.
echo Target Repository:
echo   https://github.com/muralialavalapadu-svg/student.git
echo.

:: 1. Detect or Download Git
set "GIT_CMD="

where git >nul 2>&1
if %ERRORLEVEL% equ 0 (
    set "GIT_CMD=git"
    echo [OK] Using installed Git.
) else if exist "%~dp0.git-bin\cmd\git.exe" (
    set "GIT_CMD=%~dp0.git-bin\cmd\git.exe"
    echo [OK] Using portable Git from .git-bin.
) else if exist "%LOCALAPPDATA%\Programs\Git\cmd\git.exe" (
    set "GIT_CMD=%LOCALAPPDATA%\Programs\Git\cmd\git.exe"
    echo [OK] Found Git in LocalAppData.
) else if exist "C:\Program Files\Git\cmd\git.exe" (
    set "GIT_CMD=C:\Program Files\Git\cmd\git.exe"
    echo [OK] Found Git in Program Files.
) else (
    echo [INFO] Git was not found on this system.
    echo [INFO] Automatically downloading portable Git (MinGit)...
    echo        Please wait a moment while it downloads...
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $url = 'https://github.com/git-for-windows/git/releases/download/v2.47.0.windows.2/MinGit-2.47.0.2-64-bit.zip'; $dest = Join-Path $env:TEMP 'MinGit.zip'; Write-Host 'Downloading MinGit from GitHub...'; (New-Object System.Net.WebClient).DownloadFile($url, $dest); Write-Host 'Extracting to .git-bin...'; Expand-Archive -Path $dest -DestinationPath '%~dp0.git-bin' -Force; Remove-Item $dest -Force; Write-Host 'Done!'"
    if exist "%~dp0.git-bin\cmd\git.exe" (
        set "GIT_CMD=%~dp0.git-bin\cmd\git.exe"
        echo [OK] Portable Git is ready!
    ) else (
        echo [ERROR] Could not automatically download Git.
        echo Please install Git from: https://git-scm.com/download/win
        pause
        exit /b 1
    )
)

echo.
echo ========================================================
echo Step 1: Initializing Git repository...
echo ========================================================
if not exist ".git" (
    "%GIT_CMD%" init
) else (
    echo .git already exists.
)

echo.
echo ========================================================
echo Step 2: Staging all project files...
echo ========================================================
"%GIT_CMD%" add .

echo.
echo ========================================================
echo Step 3: Creating commit...
echo ========================================================
"%GIT_CMD%" commit -m "Initial commit: Student Academic Analytics and ML Performance Prediction Portal" || (
    echo [INFO] Nothing new to commit or commit already made.
)

echo.
echo ========================================================
echo Step 4: Setting branch to main...
echo ========================================================
"%GIT_CMD%" branch -M main

echo.
echo ========================================================
echo Step 5: Configuring remote repository...
echo ========================================================
"%GIT_CMD%" remote remove origin >nul 2>&1
"%GIT_CMD%" remote add origin https://github.com/muralialavalapadu-svg/student.git

echo.
echo ========================================================
echo Step 6: Pushing entire codebase to GitHub...
echo ========================================================
echo (If prompted, log in with your GitHub account in browser or enter your Personal Access Token)
echo.
"%GIT_CMD%" push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   SUCCESS! All project files are live on GitHub:
    echo   https://github.com/muralialavalapadu-svg/student
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   Push failed or requires authentication.
    echo ========================================================
    echo If GitHub rejected the login, you can create a Personal Access Token:
    echo   1. Go to: https://github.com/settings/tokens/new
    echo   2. Generate token with 'repo' scope.
    echo   3. When prompted for password, paste that token!
)

echo.
pause
