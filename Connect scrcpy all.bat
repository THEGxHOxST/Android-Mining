@echo off
setlocal enabledelayedexpansion

:: Step 1: Connect devices (optional - if using IPs)
:: Example: Uncomment and list your device IPs if needed
adb connect 192.168.86.26:5555
adb connect 192.168.86.248:5555

:: Get list of connected devices
echo Finding connected devices...

for /f "tokens=1" %%a in ('adb devices ^| findstr /r "device$"') do (
    echo Launching scrcpy for device %%a...
    start "" cmd /c "scrcpy --serial %%a"
)

echo.
echo All scrcpy instances launched.
echo.

:: Wait for user
echo Press any key AFTER you are done to disconnect devices...
pause >nul

:: Disconnect all devices
echo Disconnecting all devices...
adb disconnect

echo Done. Goodbye!
timeout /t 2 >nul
exit