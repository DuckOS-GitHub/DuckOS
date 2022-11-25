@echo off

:: check for administrative privileges
openfiles >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ---------------------------------------
    echo info: run this file as administator
    echo ---------------------------------------
    pause & exit /b 1
)

:: set up the command prompt
color d
title DuckOS; Connect To Wi-Fi - Minitool made for DuckOS, by fikinoob

sc start wlansvc > nul
echo info: generating a list of available networks
echo ------------------
echo WLAN
echo ------------------
echo.
netsh WLAN show profiles
echo.
echo ------------------
echo LAN
echo ------------------
echo.
echo info: starting dot3svc service
net start dot3svc > nul
netsh LAN show profiles
echo Done
set /p name=info: type the network name you wanna log into:
set /p key=info: type the wifi password of the router named %name%:
cls
echo info: Name: %name%
echo info: Key: %key%
echo info: attempting to connect
del /f /q %TEMP%\*.*
ipconfig /flushdns > nul
ipconfig /release > nul
ipconfig /renew > nul
netsh wlan set hostednetwork mode=allow ssid="%name%" key="%key%"
echo info: done

echo info: press any key to exit
pause > nul & exit /b 0
