@echo off
title DuckOS - Cache Cleaner
echo Deleting Windows temporary files...
del /s /f /q c:\Windows\temp\*.*
echo Deleting prefetch files....
del /s /f /q C:\Windows\prefetch\*.*
echo Deleting temporary folder...
del /s /f /q %temp%\*.*
cd /d C:\
del *.tmp /s /q /f
