@echo off
echo.
echo info: this script will use chkdsk to check for disk errors
echo info: chkdsk is safe to use as it is built in into windows
pause
echo Y | chkdsk /r
echo Y | chkdsk /f
chkdsk %SystemDrive%
shutdown /a
shutdown /r /t 2
exit