@echo off
setlocal ENABLEDELAYEDEXPANSION

:: === Example IPs for you to manually add ===
:: Replace the below example IPs with your own 192.168.86.x IPs
set DEVICE_LIST=192.168.86.26
set DEVICE_PORT=5555

echo Starting ADB server...
adb start-server
echo.

for %%D in (%DEVICE_LIST%) do (
    echo === Trying %%D ===
    adb connect %%D:%DEVICE_PORT% >nul 2>&1
    adb -s %%D:%DEVICE_PORT% get-state >nul 2>&1

    if !errorlevel! == 0 (
        echo Connected to %%D

        echo Launching UserLAnd...
        adb -s %%D:%DEVICE_PORT% shell monkey -p tech.ula -c android.intent.category.LAUNCHER 1
        timeout /t 5 >nul

        echo Selecting Sessions button...
        adb -s %%D:%DEVICE_PORT% shell input tap 550 2300
        timeout /t 2 >nul

        echo Selecting Ubuntu session...
        adb -s %%D:%DEVICE_PORT% shell input tap 450 450
        timeout /t 5 >nul

        :: === Type the command in the session ===
        echo Typing '~/ccminer/start.sh'...
        adb -s %%D:%DEVICE_PORT% shell input text "ccminer/start.sh"
        timeout /t 2 >nul
        adb -s %%D:%DEVICE_PORT% shell input keyevent 66  :: This simulates pressing 'Enter'
        timeout /t 2 >nul

        :: === Type 'screen -x' to attach to the session ===
        echo Typing 'screen -x'...
        adb -s %%D:%DEVICE_PORT% shell input text "screen"
        adb -s %%D:%DEVICE_PORT% shell input keyevent 62   :: KEYCODE_SPACE
        adb -s %%D:%DEVICE_PORT% shell input text "-x"
        adb -s %%D:%DEVICE_PORT% shell input keyevent 62   :: KEYCODE_SPACE
        adb -s %%D:%DEVICE_PORT% shell input text "CCminer"
        adb -s %%D:%DEVICE_PORT% shell input keyevent 66  :: Simulates pressing 'Enter'
        timeout /t 2 >nul

        :: === Turn off screen to attach to the session ===
        adb -s %%D:%DEVICE_PORT% shell input keyevent 26

        echo === Done with %%D ===
        echo.
    ) else (
        echo Could not connect to %%D.
    )
)

echo All devices processed.
pause