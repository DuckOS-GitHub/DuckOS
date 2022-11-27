@echo off && cls && echo ! Loaded.
@set c=0
echo.
echo [INFO] This script will re-install all DuckOS' preinstalled apps:
echo [INFO] - 7-Zip
echo [INFO] - Open-Shell
echo [INFO] - Visual C++ Redists
pause
if exist C:\Windows\Setup\Files\7zip.msi (
    echo [INFO] 7-Zip installer found - installing
    "C:\Windows\Setup\Files\7zip.msi" /quiet
    set /a c=c+1
    echo [INFO] Done.
) else (
    echo [WARN] 7-Zip installer not found - skipping
)

if exist C:\Windows\Setup\Files\vcredist.exe (
    echo [INFO] Visual C++ Redistributables installer found - installing
    set /a c=c+1
    "C:\Windows\Setup\Files\vcredist.exe" /ai
    echo [INFO] Done.
) else (
    echo [WARN] Visual C++ Redistributables installer not found - skipping
)
if exist C:\Windows\Setup\Files\openshell.exe (
    echo [INFO] Open-Shell installer found - installing
    set /a c=c+1
    "C:\Windows\Setup\Files\openshell.exe" /qn ADDLOCAL=StartMenu
    echo [INFO] Done.
) else (
    echo [WARN] Open-Shell installer not found - skipping
)
echo [INFO] echo %c%/3 of the installers were executed. Press any key to exit
pause > nul & exit /b 1
