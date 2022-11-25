@echo off && cls && echo ! Loaded.
echo.
echo info: this will re-install all DuckOS' preinstalled apps
echo - 7-Zip
echo - Open-Shell
echo - Visual C++ Redists
pause
if exist C:\Windows\Setup\Files\7zip.msi (
	echo info: 7-Zip  installer found - installing
	"C:\Windows\Setup\Files\7zip.msi" /quiet
	echo info: Done.
)
if exist C:\Windows\Setup\Files\vcredist.exe (
	echo info: Visual C++ Redists installer found - installing
	"C:\Windows\Setup\Files\vcredist.exe" /ai
	echo info: Done.
)
if exist C:\Windows\Setup\Files\openshell.exe (
	echo info: Open-Shell installer found - installing
	"C:\Windows\Setup\Files\openshell.exe" /qn ADDLOCAL=StartMenu
	echo info: Done.
)
echo info: press any key to exit
pause > nul & exit /b 1