@echo off
REM SRTLA Windows Dependencies Installer
REM This script installs Chocolatey and MinGW-w64 if they are not already installed

echo ===========================================
echo SRTLA Windows Dependencies Installer
echo ===========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script must be run as Administrator!
    echo Please right-click on this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo Running with administrator privileges...
echo.

REM Check if Chocolatey is installed
echo Checking for Chocolatey installation...
where choco >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Chocolatey is already installed
    choco --version
) else (
    echo [INFO] Chocolatey not found. Installing Chocolatey...
    echo.
    
    REM Install Chocolatey
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command ^
        "[System.Net.ServicePointManager]::SecurityProtocol = 3072; ^
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to install Chocolatey
        pause
        exit /b 1
    )
    
    REM Refresh environment variables
    call refreshenv
    
    echo [OK] Chocolatey installed successfully
)

echo.

REM Check if MinGW is installed
echo Checking for MinGW installation...
where gcc >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] MinGW (GCC) is already installed
    gcc --version | findstr gcc
) else (
    echo [INFO] MinGW not found. Installing MinGW via Chocolatey...
    echo.
    
    REM Install MinGW via Chocolatey
    choco install mingw -y
    
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to install MinGW
        pause
        exit /b 1
    )
    
    REM Refresh environment variables
    call refreshenv
    
    echo [OK] MinGW installed successfully
)

echo.

REM Check if Git is installed (needed for version information in Makefile)
echo Checking for Git installation...
where git >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Git is already installed
    git --version
) else (
    echo [INFO] Git not found. Installing Git via Chocolatey...
    echo.
    
    REM Install Git via Chocolatey
    choco install git -y
    
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to install Git
        pause
        exit /b 1
    )
    
    REM Refresh environment variables
    call refreshenv
    
    echo [OK] Git installed successfully
)

echo.

REM Check if Make is available
echo Checking for Make utility...
where mingw32-make >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] MinGW Make is available
) else (
    where make >nul 2>&1
    if %errorLevel% == 0 (
        echo [OK] Make is available
    ) else (
        echo [INFO] Installing Make via Chocolatey...
        choco install make -y
        call refreshenv
        echo [OK] Make installed successfully
    )
)

echo.
echo ===========================================
echo Installation completed successfully!
echo ===========================================
echo.
echo You can now build SRTLA using one of these commands:
echo   make                (if make is in PATH)
echo   mingw32-make        (MinGW's make utility)
echo.
echo To build the project:
echo   1. Open a new command prompt (to refresh environment variables)
echo   2. Navigate to the project directory
echo   3. Run: make
echo.
echo Press any key to exit...
pause >nul