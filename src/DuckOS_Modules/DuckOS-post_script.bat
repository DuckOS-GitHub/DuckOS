@echo off && cls

::::::::::::::::::::::::::::::::
:: DuckOS Post Install Script ::
::::::::::::::::::::::::::::::::
REM =======
:: Quick disclaimer: If you think the script broke/changed something very important, remember that the DuckOS post script is provided AS IS, and doesn't come with ANY warranty.
REM =======

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Made by fikinoob#6487 for any Windows 10 installation ::
::             Contributed by AnhNguyen#7472             ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Set up initial title
title Do not close this window - [0/66] Preparing

:: Set the post script version
set version=0.461

:: Set up colors in echo
:: Some colors might not be used as of now, but we'll keep it.
chcp 65001 >nul 2>&1
set c_black=[30m
set c_red=[31m
set c_green=[32m
set c_gold=[33m
set c_blue=[34m
set c_purple=[35m
set c_cyan=[36m
set c_white=[37m

:: Default values
set "noRestart=0"
set "isDuck=0"
set "onlyTweak=0"
set "noUpdates=0"
set "debugMode=0"
set "network=0"
set "CFUExit=0"

:: Force the window to go maximized and clear the screen.
cls
powershell -WindowStyle Maximized Write-Host The post install script is starting...

:: Show splash text
echo ██████╗ ██╗     ███████╗ █████╗ ███████╗███████╗    ██╗    ██╗ █████╗ ██╗████████╗      
echo ██╔══██╗██║     ██╔════╝██╔══██╗██╔════╝██╔════╝    ██║    ██║██╔══██╗██║╚══██╔══╝      
echo ██████╔╝██║     █████╗  ███████║███████╗█████╗      ██║ █╗ ██║███████║██║   ██║         
echo ██╔═══╝ ██║     ██╔══╝  ██╔══██║╚════██║██╔══╝      ██║███╗██║██╔══██║██║   ██║         
echo ██║     ███████╗███████╗██║  ██║███████║███████╗    ╚███╔███╔╝██║  ██║██║   ██║██╗██╗██╗
echo ╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝╚═╝╚═╝╚═╝

:::::::::::::
:: Updater ::
:::::::::::::

:: Check if connection to GitHub is possible.
ping -n 1 raw.githubusercontent.com | findstr Reply >NUL && set network=1

:: Compare it to the one on the internet.
:: 1709 doesn't have curl, so we are gonna use powershell if curl doesnt exist
if "%network%" equ "1" (
    if exist "%TEMP%\Post-Script_ver.txt" del /f /q "%TEMP%\Post-Script_ver.txt" >NUL
    if exist "%windir%\System32\curl.exe" ( curl --progress-bar https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt -o "%TEMP%\Post-Script_ver.txt" ) else ( powershell iwr -Method Get -Uri https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt -OutFile %TEMP%\Post-Script_ver.txt )
    for /f "tokens=* USEBACKQ" %%f IN (`type %TEMP%\Post-Script_ver.txt`) do ( 
        if "%version%" LSS "%%f" ( call :UpdateDetected %%f ) else ( set "noUpdates=1" )
    )
) else (
    if "%network%" equ "0" (
        echo No network connectivity detected, skipping update!
    )
)

::::::::::::::::::::::::::::
:: Command line arguments ::
::::::::::::::::::::::::::::

:: Check if there are no arguments...
if /i "%*" == "" goto noArgs

:: Set the args as a var (incase we update)
set UpdateArgs=%*

:: Go to the correct function if one of the command line arguments is a valid one.
:: Reserved arguments are put on top and doesn't have their slash variant.
for %%i in (%*) do (
    if /i "%%i" equ "-CFUExit" set "CFUExit=1"
    if /i "%%i" equ "-isDuck" set "isDuck=1"
    if /i "%%i" equ "-updateCM" if /i "%noUpdates%"=="1" goto :noUpdates
    if /i "%%i" equ "-debug" set "debugMode=1"
    if /i "%%i" equ "-d" set "debugMode=1"
    if /i "%%i" equ "-noRestart" set "noRestart=1"
    if /i "%%i" equ "-onlyTweak" goto :tweaks
    if /i "%%i" equ "/debug" set "debugMode=1"
    if /i "%%i" equ "/d" set "debugMode=1"
    if /i "%%i" equ "/noRestart" set "noRestart=1"
    if /i "%%i" equ "/onlyTweak" goto :tweaks
)

:begin
if %debugMode% equ 1 (
    choice /n /m "You've chosen to run the script in debug mode. Echo will be set to on to display all inputs. Continue with debug mode on? [Y/N]"
    if errorlevel 2 (
        echo Debug mode is now OFF.
        @echo off
        goto tweaks
    ) else (
        if errorlevel 1 (
	    echo Alright.
	    @echo on
	    cls
	    goto tweaks
	    )
	)
    )
)
:::::::::::::
:: Credits :: 
:::::::::::::

:: DuckOS' tweaks aren't 100% made by it's author, but the author and some people's tweaks..
:: Today you cannot make a good operating system by yourself... you gotta use AT LEAST 1 source.
:: Here are credits to the people -- whose code is currently in use in this script: (no order)
:: 1. He3als - gave this idea to make DuckOS an open-sourced project
:: 2. Zusier - We used some tweaks he wrote for AtlasOS, which is an another good modified operating system based on Windows 10!
:: 3. Imribiy - NIC settings
:: 4. CatGamerOP - I used his commands... that delete registry classes :skull:
:: 5. stefkeec - Commands to block telemetry IPs
:: 6. vojt. - toolbox icons
:: 7. amit @ EVA - same thing as for 2. but just applies to amit
:: Various different sources...

:: Warning prompt
if /i "%isDuck" equ "0" (
    call :MsgBox "This script will tweak your computer. If you think the script broke/changed something very important, remember that the DuckOS post script is provided AS IS, and doesn't come with ANY warranty! Do you wanna continue?"  "VBYesNo+VBQuestion+VBDefaultButton2" "Continue?"
    if errorlevel 6 ( goto begin ) else (
        echo Alright, no changes have been made. Press any key to exit.
        pause >nul
        exit
    )
) else ( goto tweaks )

:tweaks

:: Here we go
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
:: Sure, using DISM for elev check because we're cool
DISM >NUL
if errorlevel 0 (
    goto gotPrivileges
) else (
    chcp 65001 >nul
    setlocal DisableDelayedExpansion
    title DuckOS Post Script: Permission denied
    color 0c
    echo ██╗    ██╗ █████╗ ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗ 
    echo ██║    ██║██╔══██╗██╔══██╗████╗  ██║██║████╗  ██║██╔════╝ 
    echo ██║ █╗ ██║███████║██████╔╝██╔██╗ ██║██║██╔██╗ ██║██║  ███╗
    echo ██║███╗██║██╔══██║██╔══██╗██║╚██╗██║██║██║╚██╗██║██║   ██║
    echo ╚███╔███╔╝██║  ██║██║  ██║██║ ╚████║██║██║ ╚████║╚██████╔╝
    echo  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
    echo.
    choice /n /m "Permission denied. Try again? [Y/N]"
    if errorlevel 2 (
        chcp 65001 >nul
        cls
        echo ███╗   ██╗ ██████╗     ██████╗ ███████╗██████╗ ███╗   ███╗██╗███████╗███████╗██╗ ██████╗ ███╗   ██╗
        echo ████╗  ██║██╔═══██╗    ██╔══██╗██╔════╝██╔══██╗████╗ ████║██║██╔════╝██╔════╝██║██╔═══██╗████╗  ██║
        echo ██╔██╗ ██║██║   ██║    ██████╔╝█████╗  ██████╔╝██╔████╔██║██║███████╗███████╗██║██║   ██║██╔██╗ ██║
        echo ██║╚██╗██║██║   ██║    ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██║╚════██║╚════██║██║██║   ██║██║╚██╗██║
        echo ██║ ╚████║╚██████╔╝    ██║     ███████╗██║  ██║██║ ╚═╝ ██║██║███████║███████║██║╚██████╔╝██║ ╚████║
        echo ╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
        echo.
        echo Permission denied. To properly apply the tweaks, make sure to run it as admin!
        echo Press any key to close this window... & pause >nul
	exit
    ) else (
        if errorlevel 1 (
            title Do not close this window - [0/66] Preparing
            echo Alright.
            goto getPrivileges
        )
    )
)

:getPrivileges
setlocal EnableDelayedExpansion
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
echo args = "ELEV " >> "%vbsGetPrivileges%"
echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
echo args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
echo Next >> "%vbsGetPrivileges%"
echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /b

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

:: Set a variable.. that we will use later... that points into an executable.
set currentuser=%windir%\DuckOS_Modules\nsudo.exe -U:C -P:E -Wait

:: Make the script faster by putting a higher priority on all cmd related processes.
echo %c_green%Making processes have higher priorities for faster execution.
wmic process where name="cmd.exe" CALL setpriority 32768
:: cmd.exe probably does not do the actual script execution, conhost might. idk. but just in case -WilliamAnimate
wmic process where name="conhost.exe" CALL setpriority 32768
echo %c_purple%Please wait. This may take a moment.

:: Check if the user is running the script as TrustedInstaller...
whoami|findstr /i "NT AUTHORITY\SYSTEM" >nul
if errorlevel 1 goto TrustedInstaller

:: Set the initial title
title Do not close this window, tweaking your computer!

:: Send a message!
if /i "%isDuck" equ "1" (
    call :MsgBox "Welcome to DuckOS, a modification to Windows for enhanced privacy and performance! Thank you for downloading and using DuckOS, we are preparing DuckOS and will be available to use shortly..." 64+4096 "DuckOS Post Install Tweaks"
    call :MsgBox "You will be prompted with a few questions, then you can leave your computer running and let us do the rest." 64+4096 "DuckOS Post Install Tweaks"
) else (
    call :MsgBox "You will be prompted with a few questions, then you can leave your computer running and let us do the rest." 64+4096 "DuckOS Tweaks"
)

:: Change the directory.
cd %windir%\DuckOS_Modules

:: Clear the screen
cls

:: Make the command prompt fullscreen if duckOS is detected..
if "%isDuck% equ "1" (
    :: Kill explorer to make desktop black.
    taskkill /f /im explorer.exe
    echo:Set WshShell = WScript.CreateObject("WScript.Shell")>%TEMP%\fullscreen.vbs
    echo:WshShell.SendKeys "{F11}">>%TEMP%\fullscreen.vbs
    wscript "%TEMP%\fullscreen.vbs"
    del /f /q "%TEMP%\fullscreen.vbs"
)

:: Ask the user if they use "Windows Firewall", if not, disable it.. if yes, do nothing...
title Do not close this window - [1/66] Windows Firewall
call :MsgBox "Will you use Windows Firewall? -- NOTE: By disabling Windows Firewall, it will break Microsoft Store reinstallation and some games like Overwatch 2!"  "VBYesNo+VBQuestion" "Configuration"
if errorlevel 7 (
    echo %c_green%Alright, destroying firewall...
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f
) else if errorlevel 6 (
	echo %c_green%OK! Skipped removal. Re-Enabling Windows Firewall.
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "2" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "0" /f
)

:: Ask the user if they want to use a webcam
title Do not close this window - [2/66] Webcam Setup
call :MsgBox "Are you gonna use a webcam?"  "VBYesNo+VBQuestion" "Configuration"
if errorlevel 7 (
    echo %c_green%Okay... Disabling webcam services...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\swenum" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Deny" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\NonPackaged" /v "Value" /t REG_SZ /d "Deny" /f
    if exist %windir%\DuckOS_Modules\devmanview.exe %windir%\DuckOS_Modules\devmanview.exe /disable "Plug and Play Software Device Enumerator"
) else if errorlevel 6 (
    echo %c_green%Got it, we will keep webcam services.
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Allow" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Allow" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\NonPackaged" /v "Value" /t REG_SZ /d "Allow" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\swenum" /v "Start" /t REG_DWORD /d "3" /f
    if exist %windir%\DuckOS_Modules\devmanview.exe %windir%\DuckOS_Modules\devmanview.exe /disable "Plug and Play Software Device Enumerator"
)

:: Set enviroment variables for future use, example: toolbox
title Do not close this window - [3/66] Setting environment variables...
SETLOCAL EnableDelayedExpansion
echo %c_cyan%Setting environment variables...
for /f "tokens=2 delims==" %%a in ('wmic os get TotalVisibleMemorySize /format:value ^| findstr "TotalVisibleMemorySize"') do set "TotalVisibleMemorySize=%%a"
set /a RAM=%TotalVisibleMemorySize%+1024000
echo %c_green%Done.

:: Import accent color registry file
title Do not close this window - [4/66] Importing registry
if /i "%isDuck" equ "1" (
    if exist %windir%\DuckOS_Modules\accent_color.reg ( %currentuser% "%WINDIR%\regedit.exe" /s %windir%\DuckOS_Modules\accent_color.reg )
) else (
    echo %c_green%******************************************************
    echo %c_red%We've detected that you're not using DuckOS, skipping.
    echo %c_green%******************************************************
)
:: Block every single websites telemetry with the help of a modified hosts file.
title Do not close this window - [5/66] Blocking telemetry
echo %c_blue%Blocking every single websites telemetry with the help of a modified hosts file.
if exist "%windir%\system32\curl.exe" ( curl -l -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts -o %SystemRoot%\System32\drivers\etc\hosts.temp ) else ( powershell iwr -Method Get -Uri https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts -OutFile %SystemRoot%\System32\drivers\etc\hosts.temp )
if exist %SystemRoot%\System32\drivers\etc\hosts.temp (
    cd %SystemRoot%\System32\drivers\etc
    del /f /q hosts
    ren hosts.temp hosts 
    echo %c_green%Done.
)

:: Show Detailed Information on Startup/Shutdown
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f

::::::::::::::::::::::::
:: Windows Appearance ::
::::::::::::::::::::::::

:: Enable dark mode, disable transparency and disable Task View
:: WE DON'T LIKE LIGHT MODE!
title Do not close this window - [6/66] Windows appearence
if /i "%isDuck" equ "1" (
    echo %c_green%Enabling dark mode, disabling transparency and disabling Task View...
    %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f
    %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f
    %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f
    %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f
    echo %c_green%Done.
) else (
    echo %c_red%Appearance tweaks might not fit with you, so we're skipping it.
)

title Do not close this window - [7/66] Configuring time settings
:: Set UTC to prevent issues with dual booting (specifically with Linux)
echo %c_cyan%Setting UTC to prevent issues with dual booting (specifically with Linux)...
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f >nul

:: Change the NTP server from the Windows Server to pool.ntp.org
sc config W32Time start=demand >nul 2>nul
sc start W32Time >nul 2>nul
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
sc queryex "w32time"|Find "STATE"|Find /v "RUNNING"||(
    net stop w32time
    net start w32time
) >nul 2>nul

:: Re-sync the time to pool.ntp.org
w32tm /config /update
w32tm /resync
sc stop W32Time
sc config W32Time start=disabled
.
:: Turn on automatic time update
%windir%\System32\SystemSettingsAdminFlows.exe SetInternetTime 1
:: Turn on automatic time zone update
%windir%\System32\SystemSettingsAdminFlows.exe SetAutoTimeZoneUpdate 1
:: Finally, force sync the time with the internet time
%windir%\System32\SystemSettingsAdminFlows.exe ForceTimeSync 1

:: Enable numlock on startup
reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /d "2" /t REG_DWORD /f

if /i "%isDuck" equ "1" ( goto skipPrograms )

::::::::::::::
:: Software ::
::::::::::::::

:: Install 7-zip
title Do not close this window - [8/66] Programs Installation
if exist %windir%\DuckOS_Modules\Utils\7z2201-x64.msi (
    echo %c_cyan%Installing 7-zip..
    cd %windir%\DuckOS_Modules\Utils
    start /wait "" "7z2201-x64.msi" /passive
    echo Done.
    echo Making sure 7zip is the default format for zips...
    for %%i in (".001", ".7z", ".arj", ".bz2", ".bzip2", ".cab", ".cpio", ".deb", ".dmg", ".esd", ".fat", ".gz", ".gzip", ".hfs", ".iso", ".lha", ".lzh", ".lzma", ".ntfs", ".rar", ".rpm", ".squashfs", ".swm", ".tar", ".taz", ".tbz", ".tbz2", ".tgz", ".tpz", ".txz", ".vhd", ".wim", ".xar", ".xz", ".z", ".zip") do ( reg add "HKLM\Software\Classes\.%%~i" /ve /t REG_SZ /d "7-Zip.%%~i" /f >nul 2>&1 )
    reg add "HKCU\Software\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "2147488038" /f >nul 2>&1
    reg add "HKCU\Software\7-Zip\Options" /v "ElimDupExtract" /t REG_DWORD /d "0" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,9" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,4" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,7" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,12" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,11" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,17" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.esd" /ve /t REG_SZ /d "esd Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.esd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.esd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,21" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,18" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,8" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,22" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,3" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,10" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,24" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,13" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,19" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,1" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f >nul 2>&1
    reg add "HKLM\Software\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    echo Done.
) else (
    echo %c_red%Couldn't find 7-Zip installation file! Skipping it...
)

::::::::::::::::::::
:: Install OpenShell if the OS is 1709...
::::::::::::::::::::

:: Detect if it's 1709
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseID | find "1709"
if errorlevel 0 (
    if /i "%isDuck" equ "1" (
        echo %c_red%Installing OpenShell v4.4 if it exists...
        if exist "%windir%\DuckOS_Modules\Utils\OpenShellSetup_4_4_170.exe" start /wait "" "%windir%\DuckOS_Modules\Utils\OpenShellSetup_4_4_170.exe" /qn ADDLOCAL=StartMenu
        echo %c_green%Done.
    )
)

:: Make the post script run on by default if it doesn't finish executing
:: The asterisk at the beginning (*) makes it forcefully start even in safe mode.
:: Why? People like to close the post script... and they say duckOS gives bad performance... so we make it start by default, but IF the script sucessfully runs, it deletes itself at the end.
if "%isDuck%" equ "1" ( reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" /v "*DuckOS Post Install Tweaks" /d "%~f0" /t REG_SZ /f )

:: Debloat 7zip - security [fix the 0-day chm help exploit]
cd /d %ProgramFiles%\7-zip
echo %c_cyan%Debloating 7-Zip...
for %%i in (*.txt *.chm) do del /F /Q "%%i"
rd /s /q "%programdata%\Microsoft\Windows\Start Menu\Programs\7-Zip"
echo %c_green%Done.

:: Install DirectX
if exist %SYSTEMROOT%\DuckOS_Modules\DirectX\dxsetup.exe (
    echo %c_cyan%Installing DirectX...
    start /wait "" "%SYSTEMROOT%\DuckOS_Modules\DirectX\dxsetup.exe" /silent
    echo %c_green%Done.
) else (
    echo %c_red%Couldn't find DirectX installation file! Skipping it...
)

:: Install VCRedists
if exist %windir%\DuckOS_Modules\vcredist.exe (
    echo %c_cyan%Installing VCRedists..
    cd %windir%\DuckOS_Modules
    start /wait "" "vcredist.exe" /aiV /gm2
    echo %c_green%Done.
) else (
    echo %c_red%Couldn't file VCRedists installation file! Skipping it... 
)

:: Install bleachbit
if exist %WINDIR%\DuckOS_Modules\Utils\BleachBit-4.4.2-setup.exe (
    echo %c_gold%Installing BleachBit..
    start /min /wait "" "%WINDIR%\DuckOS_Modules\Utils\BleachBit-4.4.2-setup.exe" /allusers /S
    echo %c_green%Done.
)

:skipPrograms

::::::::::::::::::::::::::
:: Remove Telemetry IPs ::
::::::::::::::::::::::::::

title Do not close this window - [9/66] Telemetry and Privacy
echo %c_red%Disabling Telemetry IPs..

:: Inbound
netsh advfirewall firewall add rule name="Block Windows Telemetry" dir=in action=block remoteip=134.170.30.202,137.116.81.24,157.56.106.189,184.86.53.99,2.22.61.43,2.22.61.66,204.79.197.200,23.218.212.69,65.39.117.23,65.55.108.23,64.4.54.254 enable=yes > nul
netsh advfirewall firewall add rule name="Block NVIDIA Telemetry" dir=out action=block remoteip=8.36.80.197,8.36.80.224,8.36.80.252,8.36.113.118,8.36.113.141,8.36.80.230,8.36.80.231,8.36.113.126,8.36.80.195,8.36.80.217,8.36.80.237,8.36.80.246,8.36.113.116,8.36.113.139,8.36.80.244,216.228.121.209 enable=yes > nul

:: Outbound
netsh advfirewall firewall add rule name="Block Windows Telemetry" dir=out action=block remoteip=134.170.30.202,137.116.81.24,157.56.106.189,184.86.53.99,2.22.61.43,2.22.61.66,204.79.197.200,23.218.212.69,65.39.117.23,65.55.108.23,64.4.54.254 enable=yes > nul
netsh advfirewall firewall add rule name="Block NVIDIA Telemetry" dir=out action=block remoteip=8.36.80.197,8.36.80.224,8.36.80.252,8.36.113.118,8.36.113.141,8.36.80.230,8.36.80.231,8.36.113.126,8.36.80.195,8.36.80.217,8.36.80.237,8.36.80.246,8.36.113.116,8.36.113.139,8.36.80.244,216.228.121.209 enable=yes > nul
echo %c_red%Done. 

:::::::::::::::::::::::::::::::::::::::::::::
:: Fully disable the telemetry with OOSU10 ::
:::::::::::::::::::::::::::::::::::::::::::::

echo Fully disabling the telemetry if O^&O ShutUp 10 exists...
if exist %windir%\DuckOS_Modules\OOSU10.exe (
	echo O^&O ShutUp10 found... disabling telemetry..
	%windir%\DuckOS_Modules\OOSU10.exe %windir%\DuckOS_Modules\duckOS_preset.cfg /quiet /nosrp
)
echo %c_green%Done.

:: Disable Data Collection (telemetry)
:: Gives you privacy :)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Known Issues when adding languages in Windows 10 -- link https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue?view=windows-10
title Do not close this window - [10/66] Bug mitigation
echo %c_cyan%Working around a Windows bug when adding languages...
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
reg add "HKLM\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t REG_DWORD /d "1" /f

:: Disable MS Edge's scheduled tasks
title Do not close this window - [11/66] Microsoft Edge
echo %c_cyan%Disabling Microsoft Edge's scheduled tasks.
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >nul 2>nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineUA" >nul 2>nul
echo %c_green%Done.

:: Edge Settings incase the user want's to install it.. so it already has settings configured.
echo %c_cyan%Configuring Edge settings incase the user reinstalls it..
reg add "HKLM\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Remove Edge from Program Files (x86)
echo %c_green%Removing Edge from Program Files (x86)...
rd /s /q "C:\Program Files (x86)\Microsoft"
echo %c_green%Done.

:: Remove Edge's registry keys
echo %c_cyan%Removing Edge's registry keys / leftovers...
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f >nul 2>nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f >nul 2>nul
reg delete "HKLM\Software\Classes\MSEdgeHTM" /f >nul 2>nul
reg delete "HKLM\System\CurrentControlSet\Services\EventLog\Application\edgeupdate" /f >nul 2>nul
reg delete "HKLM\System\CurrentControlSet\Services\EventLog\Application\edgeupdatem" /f >nul 2>nul
reg delete "HKLM\Software\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f >nul 2>nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >nul 2>nul
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f >nul 2>nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\EdgeUpdate" /f >nul 2>nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Edge" /f >nul 2>nul
reg delete "HKLM\Software\Clients\StartMenuInternet\Microsoft Edge" /f >nul 2>nul
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /f >nul 2>nul
echo %c_green%Done.

:: Skip some parts that should be exclusive only to DuckOS
if /i %isDuck% equ 0 ( goto :notDuck )

::::::::::::::::::
:: Context Menu ::
::::::::::::::::::

title Do not close this window - [12/66] Context Menu
echo %c_cyan%Setting up the toolbox and "check for updates" in the context menu..

:: Set up the template and it's functions
reg add "HKCR\DesktopBackground\Shell\DuckOS" /ve /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS" /v "Position" /t REG_SZ /d "Bottom" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS" /v "Icon" /t REG_SZ /d "shell32.dll,-47" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS" /v "SubCommands" /t REG_SZ /d "" /f

:: Set up "check for updates" and the toolbox in the context menu..
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\Check for DuckOS updates" /v "Icon" /t REG_SZ /d "shell32.dll,-193" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\Check for DuckOS updates\Command" /ve /t REG_SZ /d "%~0 -updateCM" /f
echo %c_green%Done.

:: Set up the toolbox to be in the context menu..
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\DuckOS Toolbox" /v "MUIVerb" /t REG_SZ /d "DuckOS Toolbox" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\DuckOS Toolbox" /v "Icon" /t REG_SZ /d "shell32.dll,-25" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\DuckOS Toolbox\Command" /ve /t REG_SZ /d "\"%SystemRoot%\DuckOS_Modules\DuckOS_Toolbox\DuckOS Toolbox.exe\"" /f
echo %c_green%Done.

:: Set up the "Kill not responding apps" button in the context menu..
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\KillNotResponding" /v "MUIVerb" /t REG_SZ /d "Kill not responding apps" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\KillNotResponding" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\imageres.dll,-98" /f
reg add "HKCR\DesktopBackground\Shell\DuckOS\Shell\KillNotResponding\Command" /ve /t REG_SZ /d "cmd.exe /c taskkill.exe /F /FI \"status eq NOT RESPONDING\"" /f

:: Make the computer restart 1 time after the current restart, because THAT fixed OS issues
title Do not close this window - [13/66] Configuring restart
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "*Silent System Restart" /t REG_SZ /d "%windir%\System32\shutdown.exe -r -t 0 -f" /f

:: Start menu layout
:: source: atlas
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%windir%\System32\start-menu_layout.xml" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "%windir%\System32\start-menu_layout.xml" /f

:: Import the powerplan BASED on your processor
:: Explanation: AMD has worse speeds, more cores, IDLE isn't ideal, Intel has faster speeds, but less cores, IDLE is ideal.
title Do not close this window - [14/66] Power Plan
echo %c_green%Importing a custom power plan based on your processor..

:::::::::::::::::::::::::
:: Processor detection ::
:::::::::::::::::::::::::

:: Intel detection
wmic cpu get name|find /i "Intel"
set INTEL=%errorlevel%

:: AMD detection
wmic cpu get name|find /i "AMD"
set AMD=%errorlevel%

:: Checking the processor...
if %INTEL% equ 0 (
    echo $ Intel processor detected, making sure power plan = idle OFF
    echo $ MIGHT CAUSE THE CPU % TO BE INACCURATE!
    powercfg -import "%windir%\DuckOS_Modules\Duck.pow" d6344778-a03d-4e00-a73a-dbc3f3f5f236
    powercfg /setactive d6344778-a03d-4e00-a73a-dbc3f3f5f236
) else if %AMD% equ 0 (
    echo $ AMD processor detected, making sure the power plan = idle ON
    echo $ Also making sure some AMD unneeded services aren't gonna start...
    powercfg -import "%windir%\DuckOS_Modules\Duck_IDLE_ENABLED.pow" d6344778-a03d-4e00-a73a-dbc3f3f5f236
    powercfg /setactive d6344778-a03d-4e00-a73a-dbc3f3f5f236
    for %%i in ("HKLM\SYSTEM\CurrentControlSet\Services\AMD Log Utility" "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" "HKLM\SYSTEM\CurrentControlSet\Services\AMD External Events Utility") do ( reg add %%i /v Start /t REG_DWORD /d 4 /f )
)
echo %c_green%Done.

:: MAKE THE CACHE CLEANER START ON STARTUP by modifying the shell value...
title Do not close this window - [15/66] Cache Cleaner
echo %c_green%Making the cache cleaner run on startup..
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "%windir%\explorer.exe, C:\ProgramData\Cache_Cleaner.bat" /F
echo %c_green%Done.

:: Make memreduct start on by default...
echo %c_gold%Making memreduct start by default...
attrib +s %windir%\DuckOS_Modules
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Memory reduct" /d "%windir%\DuckOS_Modules\Utils\memreduct.exe" /t REG_SZ /f
echo %c_green%Done.
echo %c_gold%Writing memreduct configuration file...
>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:[memreduct]
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:CheckUpdatesLast=1668361365
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:IsShowReductConfirmation=false
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:StatisticLastReduct=1668361861
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:IsStartMinimized=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:CheckUpdatesPeriod=0
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:AutoreductEnable=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:AutoreductIntervalEnable=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:HotkeyCleanEnable=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:SettingsLastPage=102
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:ReductMask2=39
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:AutoreductIntervalValue=1
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:TrayRoundCorners=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:TrayShowBorder=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:TrayUseTransparency=true
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:TrayUseAntialiasing=false
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:BalloonCleanResults=false
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:IsNotificationsSound=false
>>"%APPDATA%\Henry++\Mem Reduct\memreduct.ini" echo:IsTrayIconSingleClick=false
echo %c_green%Done.

:: Make the cache cleaner a protected sys file
attrib +r +s %windir%\ProgramData\Cache_Cleaner.bat

:notDuck

:: Disable unneeded Tasks -- already credited
title Do not close this window - [16/66] Disabling unneeded scheduled tasks
echo %c_cyan%Disabling unneeded scheduled tasks...
for %%a in ("\Microsoft\Windows\PushToInstall\LoginCheck" "\Microsoft\Windows\Ras\MobilityManager" "\Microsoft\Windows\UpdateOrchestrator\Reportpolicies" "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" "\Microsoft\Windows\ApplicationExperience\StartupAppTask" "\Microsoft\Windows\WindowsUpdate\ScheduledStart" "\Microsoft\Windows\Shell\FamilySafetyMonitor" "\Microsoft\Windows\Shell\FamilySafetyMonitor" "\Microsoft\Windows\WindowsErrorReporting\QueueReporting" "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" "\Microsoft\Windows\Diagnosis\Scheduled" "\Microsoft\Windows\DiskFootprint\StorageSense" "\Microsoft\Windows\MobileBroadbandAccounts\MNOMetadataParser" "\Microsoft\Windows\PushToInstall\LoginCheck" "\Microsoft\Windows\PowerEfficiencyDiagnostics\AnalyzeSystem" "\Microsoft\Windows\DiskCleanup\SilentCleanup" "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" "\Microsoft\Windows\Diagnosis\Scheduled" "\Microsoft\Windows\UpdateOrchestrator\ScheduleScanStaticTask" "\MicrosoftEdgeUpdateBrowserReplacementTask" "\Microsoft\Windows\WindowsUpdate\ScheduledStart" "\Microsoft\Windows\UPnP\UPnPHostConfig" "\Microsoft\Windows\DiskFootprint\Diagnostics" "\Microsoft\Windows\WindowsFilteringPlatform\BfeOnLoltartTypeChange" "\Microsoft\Windows\International\SynchronizeLanguageSettings" "\Microsoft\Windows\UpdateOrchestrator\ScheduleWork" "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" "\Microsoft\Windows\ApplicationExperience\PcaPatchDbTask" "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" "\Microsoft\Windows\WindowsFilteringPlatform\BfeOnServiceStartTypeChange" "\Microsoft\Windows\WaaSMedic\PerformRemediation" "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" "\Microsoft\Windows\Autochk\Proxy" "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" "\Microsoft\Windows\InstallService\SmartRetry" "\Microsoft\Windows\Printing\EduPrintProv" "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" "\Microsoft\Windows\UpdateOrchestrator\Reportpolicies" "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" "\Microsoft\Windows\Wininet\CacheTask" "\Microsoft\Windows\Ras\MobilityManager" "\Microsoft\Windows\DiskCleanup\SilentCleanup" "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" "\Microsoft\Windows\StateRepository\MaintenanceTasks" "\Microsoft\Windows\DeviceSetup\MetadataRefresh" "\Microsoft\Windows\WaaSMedic\PerformRemediation" "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" "\Microsoft\Windows\UpdateOrchestrator\ScheduleScan" "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" "\Microsoft\Windows\Autochk\Proxy" "\Microsoft\Windows\BrokerInfrastructure\BgTaskregistrationMaintenanceTask" "\Microsoft\Windows\Wininet\CacheTask" "\Microsoft\Windows\ApplicationExperience\PcaPatchDbTask" "\Microsoft\Windows\UpdateOrchestrator\ScheduleWork" "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" "\Microsoft\Windows\ApplicationExperience\MicrosoftCompatibilityAppraiser" "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" "\Microsoft\Windows\ApplicationExperience\StartupAppTask" "\Microsoft\Windows\International\SynchronizeLanguageSettings" "\Microsoft\Windows\ApplicationExperience\MicrosoftCompatibilityAppraiser" "\Microsoft\Windows\UpdateOrchestrator\ScheduleScan" "\Microsoft\Windows\UPnP\UPnPHostConfig" "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" "\Microsoft\Windows\registry\regIdleBackup" "\Microsoft\Windows\Printing\EduPrintProv" "\Microsoft\Windows\MobileBroadbandAccounts\MNOMetadataParser" "\Microsoft\Windows\WindowsErrorReporting\QueueReporting" "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" "\Microsoft\Windows\DiskFootprint\Diagnostics" "\Microsoft\Windows\InstallService\ScanForUpdates" "\Microsoft\Windows\Defrag\ScheduledDefrag" "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" "\Microsoft\Windows\DeviceSetup\MetadataRefresh" "\Microsoft\Windows\StateRepository\MaintenanceTasks" "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" "\Microsoft\Windows\UpdateOrchestrator\ScheduleScanStaticTask" "\Microsoft\Windows\PowerEfficiencyDiagnostics\AnalyzeSystem") do (
    schtasks /Change /Disable /TN %%a
)
echo %c_green%Done.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Delete lot's of registry classes, credits goes to: FoxOS ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
title Cleaning up registry classes
echo %c_cyan%Cleaning up registry classes, credit: FoxOS -- CatGamerOP
for %%a in ({990A2BD7-E738-46C7-B26F-1CF8FB9F1391} {4116F60B-25B3-4662-B732-99A6111EDC0B} {D94EE5D8-D189-4994-83D2-F68D7D41B0E6} {E0CBF06C-CD8B-4647-BB8A-263B43F0F974} {C06FF265-AE09-48F0-812C-16753D7CBA83} {D48179BE-EC20-11D1-B6B8-00C04FA372A7} {997B5D8D-C442-4F2E-BAF3-9C8E671E9E21} {6BDD1FC1-810F-11D0-BEC7-08002BE2092F} {4D36E97B-E325-11CE-BFC1-08002BE10318} {A0A588A4-C46F-4B37-B7EA-C82FE89870C6} {7EBEFBC0-3200-11D2-B4C2-00A0C9697D07} {4D36E965-E325-11CE-BFC1-08002BE10318} {53D29EF7-377C-4D14-864B-EB3A85769359} {4658EE7E-F050-11D1-B6BD-00C04FA372A7} {6BDD1FC5-810F-11D0-BEC7-08002BE2092F} {DB4F6DDD-9C0E-45E4-9597-78DBBAD0F412} {4D36E978-E325-11CE-BFC1-08002BE10318} {4D36E977-E325-11CE-BFC1-08002BE10318} {6D807884-7D21-11CF-801C-08002BE10318} {CE5939AE-EBDE-11D0-B181-0000F8753EC4} {4D36E969-E325-11CE-BFC1-08002BE10318} {4D36E970-E325-11CE-BFC1-08002BE10318} {4D36E979-E325-11CE-BFC1-08002BE10318} {4D36E96D-E325-11CE-BFC1-08002BE10318}) do (
    reg delete "HKLM\System\CurrentControlSet\Control\Class\%%a" /f
)

echo %c_green%Done.

:: Disable "JUMBOPACKET"
title Do not close this window - [17/66] Disabling JUMBOPACKET
echo %c_red%Disabling JUMBOPACKETing...
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
        for /f %%i in ('echo %%a ^| findstr "{"') do (
			for %%a in (JumboPacket) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /s /f "*%%a" ^| findstr "HKEY"') do reg add "%%b" /v "*%%a" /t REG_SZ /d "1514" /f > NUL 2>&1
		)
    )
)
echo %c_green%Done.

:: Enable "RSS" IF supported
title Do not close this window - [18/66] Enabling RSS
echo %c_cyan%Enabling RSS if supported...
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
        for /f %%i in ('echo %%a ^| findstr "{"') do (
			for %%a in (RSS) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /s /f "*%%a" ^| findstr "HKEY"') do reg add "%%b" /v "*%%a" /t REG_SZ /d "1" /f > NUL 2>&1
		)
    )
)
echo %c_green%Done.

:: Disable "MAINTENANCE"
title Do not close this window - [19/66] Disabling Maintenance
echo %c_cyan%Disabling MAINTENANCE...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScheduledDiagnostics" /v "EnabledExecution" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c_green%Done.

:: Delete Adobe Font Type Manager
title Do not close this window - [20/66] Deleting Adobe Font Type Manager
echo %c_red%Deleting Adobe Font Type Manager...
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f
echo %c_green%Done.

:: Disable Camera Access when locked
title Do not close this window - [21/66] Camera Access
echo %c_red%Disabling camera access when the PC is on lock screen.
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable Remote Assistance
title Do not close this window - [22/66] Disabling Remote Assistance
echo %c_red%Disabling Remote Assistance.
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Disable "Network Level Authentication"
title Do not close this window - [23/66] Disabling Network Level Authentication
echo %c_red%Disabling Network Level Authentication.
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Configure NIC Settings
title Do not close this window - [24/66] Configuring NIC Settings
echo %c_cyan%Configuring NIC settings...
netsh int tcp set global timestamps=disabled
netsh int tcp set heuristics disabled
netsh int tcp set supplemental Internet congestionprovider=ctcp
netsh int tcp set global rsc=disabled

for /f "tokens=1" %%i in ('netsh int ip show interfaces ^| findstr [0-9]') do (
	netsh int ip set interface %%i routerdiscovery=disabled store=persistent
)

:: Disable Web in Search
title Do not close this window - [25/66] Disabling Bing
echo %c_green%Disabling Bing in Windows Search...
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable Network Adapters
:: IPv6, Client for Microsoft Networks, QoS Packet Scheduler, File and Printer Sharing
title Do not close this window - [26/66] Disabling some network adapters...
echo %c_red%Disabling some network adapters...
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_pacer, ms_server" >nul 2>&1

:: Mitigate against HiveNightmare/SeriousSAM
title Do not close this window - [27/66] Mitigating a security vulnerability...
echo %c_cyan%Mitigating a security vulnerability...
icacls %SystemRoot%\system32\config\* /inheritance:e
echo %c_green%Done.

:: Disable TsX to mitigate ZombieLoad
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d 1 /f

:: Remove SOME dependencies
title Do not close this window - [28/66] Removing some dependencies...
echo %c_red%Removing some dependencies..
reg add "HKLM\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f
reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f
reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t REG_MULTI_SZ /d "" /f
reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ  /d "" /f
reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ  /d "" /f
echo %c_green%Done.

:: Set strong cryptography on 64 bit and 32 bit .Net Framework (version 4 and above) to fix a Scoop installation issue
:: Link to the source: https://github.com/ScoopInstaller/Scoop/issues/2040#issuecomment-369686748
title Do not close this window - [29/66] Fixing Scoop Installation issue...
echo %c_cyan%Fixing Scoop installation issue...
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\.NetFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable CEIP
title Do not close this window - [30/66] Disabling CEIP
echo %c_red%Disabling CEIP..
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: BSOD settings
title Do not close this window - [31/66] Configuring BSoD settings...
echo %c_cyan%Configuring BSOD settings...
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable Windows Insider and Build Previews
title Do not close this window - [32/66] Disabling Windows Insider
echo %c_cyan%Disabling Windows Insider and build previews...
reg add "HKLM\Software\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Change Folder options
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f

:: Remove "- Shortcut" text from shortcuts
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /t REG_SZ /d "\"%%s.lnk\"" /f

:: Maps Updates/Downloads
title Do not close this window - [33/66] Maps Updates/Downloads
echo %c_cyan%Configuring map updates/downloads..
reg add "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Application Compatibility Settings
title Do not close this window - [34/66] Application Compatibility
echo %c_cyan%Configuring 'Application Compatibility' settings...
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable Mouse Acceleration
title Do not close this window - [35/66] Disabling mouse acceleration
echo %c_cyan%Disabling Mouse Acceleration..
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
echo %c_green%Done.

:: Just read: http://www.apdl.org.uk/riscworld/volumes/volume4/issue4/makemode2/index.htm
:: Works for Windows 7 and up..
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "DisableIndependentFlip" /t REG_DWORD /d "1" /f 

:: Disable Annoying Keyboard Features
:: Who needs those shift spamming stuff?
title Do not close this window - [36/66] Disabling annoying keyboard features
echo %c_cyan%Disabling annoying/accessibility keyboard features..
%currentuser% reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Disable Connection Checking (pings Microsoft Servers)
:: May cause internet icon to show it is disconnected
title Do not close this window - [37/66] Disabling connection checking
echo %c_cyan%Disabling probing... This may cause the internet icon to show no internet.
reg add "HKLM\System\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Disable Download-Blocking and the "Windows protected your PC" dialogue if you are using Windows Defender lmao
echo %c_cyan%Disabling download blocking...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Misc Quality of Life
title Do not close this window - [38/66] Configuring misc. QoL keys...
echo %c_cyan%Configuring some QoL keys...
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f

:: Disable GPU Preemption
:: Works for Windows 8 and up.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t REG_DWORD /d "0" /f

:: Remove "Open PowerShell window here" from Shift+Right-click context menus
if /i "%isDuck" equ "1" (
    reg delete "HKCR\Directory\Background\shell\Powershell" /f
    reg delete "HKCR\Directory\shell\Powershell" /f
    reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoRestartShell" /t REG_DWORD /d "1" /f
)

:: Add "Open Command Prompt here" to context menus
if /i "%isDuck" equ "1" (
    reg delete "HKCR\Directory\shell\cmd" /f
    reg delete "HKCR\Directory\Background\shell\cmd" /f
    reg add "HKCR\Directory\shell\runas" /v "" /t REG_SZ /d "Open Command Prompt here" /f
    reg add "HKCR\Directory\shell\runas" /v "Icon" /t REG_SZ /d "cmd.exe" /f
    reg add "HKCR\Directory\shell\runas" /v "NeverDefault" /t REG_SZ /d "" /f
    reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
    reg add "HKCR\Directory\shell\runas" /v "Position" /t REG_SZ /d "Top" /f
    reg add "HKCR\Directory\shell\runas\command" /v "" /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
    reg add "HKCR\Directory\Background\shell\runas" /v "" /t REG_SZ /d "Open Command Prompt here" /f
    reg add "HKCR\Directory\Background\shell\runas" /v "Icon" /t REG_SZ /d "cmd.exe" /f
    reg add "HKCR\Directory\Background\shell\runas" /v "NeverDefault" /t REG_SZ /d "" /f
    reg add "HKCR\Directory\Background\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
    reg add "HKCR\Directory\Background\shell\runas" /v "Position" /t REG_SZ /d "Top" /f
    reg add "HKCR\Directory\Background\shell\runas\command" /v "" /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
    reg add "HKCR\LibraryFolder\Shell\runas" /v "" /t REG_SZ /d "Open Command Prompt here" /f
    reg add "HKCR\LibraryFolder\Shell\runas" /v "Icon" /t REG_SZ /d "cmd.exe" /f
    reg add "HKCR\LibraryFolder\Shell\runas" /v "NeverDefault" /t REG_SZ /d "" /f
    reg add "HKCR\LibraryFolder\Shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
    reg add "HKCR\LibraryFolder\Shell\runas" /v "Position" /t REG_SZ /d "Top" /f
    reg add "HKCR\LibraryFolder\Shell\runas\command" /v "" /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
    reg add "HKCR\LibraryFolder\background\shell\runas" /v "" /t REG_SZ /d "Open Command Prompt here" /f
    reg add "HKCR\LibraryFolder\background\shell\runas" /v "Icon" /t REG_SZ /d "cmd.exe" /f
    reg add "HKCR\LibraryFolder\background\shell\runas" /v "NeverDefault" /t REG_SZ /d "" /f
    reg add "HKCR\LibraryFolder\background\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
    reg add "HKCR\LibraryFolder\background\shell\runas" /v "Position" /t REG_SZ /d "Top" /f
    reg add "HKCR\LibraryFolder\background\shell\runas\command" /v "" /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f
)

:: Disable wide context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f

:: Remove Desktop from This PC
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f

:: Remove Documents from This PC
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f

:: Remove Downloads from This PC
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f

:: Remove Music from This PC
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f

:: Remove Pictures from This PC
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f

:: Remove Videos from This PC
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
reg delete "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f

:: Enable Windows Installer in Safe Mode
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\MSIServer" /v "" /t REG_SZ /d "Service" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\MSIServer" /v "" /t REG_SZ /d "Service" /f

:: Content Delivery Manager
title Do not close this window - [39/66] Configuring Delivery Manager
echo %c_cyan%Configuring Content Delivery Manager...

for %%a in (310093 353698 314563 338389 338387 338388 338393) do (
    %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-%%aEnabled" /t REG_DWORD /d "0" /f
)

for %%a in (RotatingLockScreenOverlayEnabled RotatingLockScreenEnabled SoftLandingEnabled SystemPaneSuggestionsEnabled SilentInstalledAppsEnabled ContentDeliveryAllowed) do (
    %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "%%a" /t REG_DWORD /d "0" /f
)

echo %c_green%Done.

:: Disable Sleep Study
title Do not close this window - [40/66] Disabling Sleep Study
echo %c_red%Disabling sleep study...
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Power
title Do not close this window - [41/66] Tweaking power settings
echo %c_green%Tweaking power settings...
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable Shared Experiences
title Do not close this window - [42/66] Disabling Shared Experiences
echo %c_red%Disabling Shared Experiences...
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Internet Explorer settings... who really uses it.. but still it's good to download librewolf lmfao
title Do not close this window - [43/66] Configuring Internet Explorer
echo %c_cyan%Configuring Internet Explorer...
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f
echo %c_green%Done.

:: Disable Remote Desktop
title Do not close this window - [44/66] Disabling Remote Desktop
echo %c_red%Disabling Remote Desktop...
reg add "HKLM\SYSTEM\CurRentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d "1" /f

:: Hide audio devices that AREN'T connected.
title Do not close this window - [45/66] Hiding disconnected audio devices...
echo %c_cyan%Hiding disconnected audio devices...
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d "0" /f >nul 2>&1
echo %c_green%Done.

:: Restore the photo viewer from Windows 7
title Do not close this window - [46/66] Photo Viewer
echo %c_cyan%Restoring photo viewer from windows 7...
for %%i in (tif tiff bmp dib gif jfif jpe jpeg jpg jxr png) do ( reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".%%~i" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul 2>&1 )
echo %c_green%Done.

:: Windows Media Player configuration
title Do not close this window - [47/66] Configuring WMP
echo %c_cyan%Configuring Media Player..
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "AcceptedEULA" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "FirstTime" /t REG_DWORD /d "1" /f >nul 2>&1
echo %c_green%Done.

:: MMCS (Multimedia Class Scheduler Service) Settings
title Do not close this window - [48/66] Configuring MMCSS
echo %c_cyan%Configuring MMCSS...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "20" /f
echo %c_green%Done.

:: Disallow Background Apps
title Do not close this window - [49/66] Disallowing background apps
echo %c_cyan%Disallowing background apps...
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Set Win32PrioritySeparation 26 hex/38 dec.
:: Explanation: "foreground processes more priority and make your CPU faster" 
:: Guide: https://richannel.org/win32-priority-separation/
title Do not close this window - [50/66] Setting Win32PrioritySeparation
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f

:: Disable Notification/Action Center
:: We will use balloons instead.
title Do not close this window - [51/66] Disabling Action Center
echo %c_green%Disabling notifications ^& Action Center...
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f
%currentuser% reg add HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer /v EnableLegacyBalloonNotifications /t REG_DWORD /d 1 /f

:: Misc stuff
title Do not close this window - [52/66] Miscellaneous
echo %c_cyan%Please wait...
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "80" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "500" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9A12038010000000" /f
echo %c_green%Done.

:: Visual Settings
title Do not close this window - [53/66] Disabling animations
echo %c_red%Disabling animations...
%currentuser% reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
echo %c_green%Done.

:: Disable Storage Sense
title Do not close this window - [54/66] Disabling Storage Sense
echo %c_red%Disabling Storage Sense..
reg add "HKLM\Software\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d "0" /f
echo %c_green%Done.

:: Enable Virtualization Based Protection of code integrity
title Do not close this window - [55/66] Enabling VBPoCI
echo %c_cyan%Enabling Virtualization Based Protection of Code Integrity
reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f

::::::::::::::::::
:: Context Menu ::
::::::::::::::::::
title Do not close this window - [56/66] Configuring context menu
echo %c_cyan%Configuring context menu...

:: Install .CAB files in the "Context Menu"
reg delete "HKCR\CABFolder\Shell\RunAs" /f >nul 2>nul
reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f
reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k dism /online /add-package /packagepath:\"%%1\"" /f

:: Remove "Include in library" in the context menu
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul
reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul

:: Remove Share in context menu
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>nul
echo %c_green%Done.

:: Double click to import power-plans, but not set them automaticlly.
title Do not close this window - [57/66] Please wait
echo %c_cyan%Please wait...
reg add "HKLM\Software\Classes\powerplan\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\powercpl.dll,1" /f
reg add "HKLM\Software\Classes\powerplan\Shell\open\command" /ve /t REG_SZ /d "powercfg /import \"%%1\"" /f
reg add "HKLM\Software\Classes\.pow" /ve /t REG_SZ /d "powerplan" /f
reg add "HKLM\Software\Classes\.pow" /v "FriendlyTypeName" /t REG_SZ /d "PowerPlan" /f
echo %c_green%Done.

:: Set CSRSS to be a "high priority" process.
:: CSRSS is responsible for mouse input latency, setting to high may yield an improvement in input latency.
title Do not close this window - [58/66] Setting CSRSS' priority
echo %c_cyan%Setting CSRSS' priority to help improve input latency...
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f
echo %c_green%Done.

:::::::::::::::::::::::::::
:: Storage Optimizations ::
:::::::::::::::::::::::::::

title Do not close this window - [59/66] Optimizing Storage
echo %c_cyan%Optimizing storage...
fsutil behavior set memoryusage 2 >NUL 2>&1
fsutil behavior set mftzone 2 >NUL 2>&1
fsutil behavior set allowextchar 0 >NUL 2>&1
fsutil behavior set Bugcheckoncorrupt 0 >NUL 2>&1
fsutil behavior set disable8dot3 1 >NUL 2>&1
fsutil behavior set disablecompression 1 >NUL 2>&1
fsutil behavior set disabledeletenotify 0 >NUL 2>&1
fsutil behavior set disabledeletenotify refs 0 >NUL 2>&1
fsutil behavior set disableencryption 1 >NUL 2>&1
fsutil behavior set disablelastaccess 1 >NUL 2>&1
fsutil behavior set encryptpagingfile 0 >NUL 2>&1
fsutil behavior set quotanotify 86400 > NUL 2>&1
fsutil behavior set symlinkevaluation L2L:1 > NUL 2>&1

:: Disable "self-healing" on the system drive (C:\)
fsutil repair set c: 0 >NUL 2>&1
echo %c_green%Done.

::::::::::::::::::::::::::
:: Memory Optimizations ::
::::::::::::::::::::::::::

title Do not close this window - [60/66] Optimizing memory
echo %c_cyan%Optimizing memory...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f

:: Set SvcSplitThreshold In KB
reg add "HKLM\System\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t reg_DWORD /d "%ram%" /f >NUL 2>&1

:: Set Large System Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t reg_DWORD /d "1" /f >NUL 2>&1

:: Disable startup delay for RunOnce and Run keys.. and more.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t reg_DWORD /d "0" /f >NUL 2>&1
echo %c_green%Done.

:: Make the post install desktop folder read only with attributes
if /i "%isDuck" equ "1" (
    echo %c_gold%Making the post install desktop folder read only with attributes..
    if exist "%userprofile%\Desktop\DuckOS - Post Install Folder" attrib +r +a +s "%userprofile%\Desktop\DuckOS - Post Install Folder"
    echo %c_green%Done.
)

:::::::::::::::::
:: Mitigations ::
:::::::::::::::::

:: Misc
title Do not close this window - [61/66] Optimizing system
echo %c_cyan%Optimizing system...

:: Disable DmaRemapping - disabling cause it can be exploited
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible ^| find /i "Services\" ') do (
	reg add "%%i" /v "DmaRemappingCompatible" /t reg_DWORD /d "0" /f >NUL 2>&1
)

:: Thread Priority tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdkmdap\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\services\mouhid\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters" /v "ThreadPriority" /t REG_DWORD /d "31" /f

:: Disable Chain Validation
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t reg_DWORD /d "1" /f >NUL 2>&1

:: Disable the FTH (Fault Tolerant Heap)
reg add "HKLM\Software\Microsoft\FTH" /v "Enabled" /t reg_DWORD /d "0" /f >NUL 2>&1

:: CSRSS mitigations
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationAuditOptions /t reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationOptions /t reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v CpuPriorityClass /t reg_DWORD /d "3" /f >NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v IoPriority /t reg_DWORD /d "3" /f >NUL 2>&1

:: Set System Processes Priority below normal
for %%i in (lsass.exe sppsvc.exe SearchIndexer.exe fontdrvhost.exe sihost.exe ctfmon.exe) do ( reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f )

:::::::::::::::::::::::
:: PowerShell Tweaks ::
:::::::::::::::::::::::

:: Generate the script
if exist %windir%\Temp\disable.ps1 ( del /f /q %windir%\Temp\disable.ps1 )
for %%i in (DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError) do echo Set-ProcessMitigation -System -Disable %%i>>%WINDIR%\Temp\disable.ps1
powershell -ep bypass -mta %windir%\Temp\disable.ps1

:: Set background apps priority below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe Discord.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f
)

:: Correct Mitigation Values
powershell -NoProfile -Command Set-ProcessMitigation -System -Disable CFG >NUL 2>&1
for /f "tokens=3 skip=2" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do set mitigation_mask=%%a
for /L %%a in (0,1,9) do (
    set mitigation_mask=!mitigation_mask:%%a=2!
)
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t reg_BINARY /d "%mitigation_mask%" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t reg_BINARY /d "%mitigation_mask%" /f >NUL 2>&1

:: ASLR - find ntoskrnl strings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Spectre & Meltdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d "3" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d "3" /f >NUL 2>&1

:: DWM
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Security Tweaks 
reg add "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" /v "RestrictNullSessAccess" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" /v "DisableCompression" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f >NUL 2>&1

:: Enable Hardware Accelerated Scheduling (HAGS)
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t reg_DWORD /d "2" /f >NUL 2>&1

:: Restrict Windows' communication
reg add "HKLM\Software\Policies\Microsoft\InternetManagement" /v "RestrictCommunication" /t REG_DWORD /d "1" /f

:: Mouse Settings
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t reg_SZ /d "10" /f >NUL 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t reg_SZ /d "0" /f >NUL 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t reg_SZ /d "0" /f >NUL 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t reg_SZ /d "0" /f >NUL 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t reg_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000 /f >NUL 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t reg_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f >NUL 2>&1

:: Disable Windows Error Reporting
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f

:: Delete the defaultuser0 account which is used during OOBE and is no longer needed
net user defaultuser0 /delete >NUL 2>&1 

:: Disable the "Administrator" account which can be exploited.. that's why we disable it.
if "%isDuck%" equ "1" (
    net user administrator /active:no >NUL 2>&1 
    echo %c_green%Done.
)

::::::::::::::
:: Internet ::
::::::::::::::

title Do not close this window - [62/66] Configuring Internet settings
echo %c_cyan%Configuring internet settings...
:: Disable Nagle's Algorithm
reg add "HKLM\Software\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t reg_DWORD /d "00000001" /f >NUL 2>&1  
for /f %%s in ('reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
 	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TCPNoDelay" /t reg_DWORD /d "1" /f >NUL 2>&1
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpAckFrequency" /t reg_DWORD /d "1" /f >NUL 2>&1
	reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpDelAckTicks" /t reg_DWORD /d "0" /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpInitialRTT" /d "300" /t REG_DWORD /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "DeadGWDetectDefault" /d "1" /t REG_DWORD /f >NUL 2>&1
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "UseZeroBroadcast" /d "0" /t REG_DWORD /f >NUL 2>&1
)

:::::::::
:: TCP ::
:::::::::

:: Enable DNS over HTTPS
:: Manual guide: https://www.nextofwindows.com/how-to-enable-dns-over-http-doh-on-windows-10-or-edge-chromium 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d "2" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f >NUL 2>&1

:: Set max port to 65535
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t reg_DWORD /d "00065534" /f >NUL 2>&1

:: Reduce TIME_WAIT
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t reg_DWORD /d "00000030" /f >NUL 2>&1

:: Disable the TCP autotuning diagnostic tool
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t reg_DWORD /d "00000000" /f >NUL 2>&1

:: Enable TCP Extensions for High Performance
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t reg_DWORD /d "00000001" /f >NUL 2>&1 

:: Detect congestion fail to receive acknowledgement for a packet within the estimated timeout
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t reg_DWORD /d "00000001" /f >NUL 2>&1

:: Set the maximum number of concurrent connections (per server endpoint) allowed when making requests using an HttpClient object.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPerServer" /t reg_DWORD /d "00000016" /f >NUL 2>&1

:: Maximum number of HTTP 1.0 connections to a Web server
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MaxConnectionsPer1_0Server" /t reg_DWORD /d "00000016" /f >NUL 2>&1

:: TCP Congestion Control/Avoidance Algorithm
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >NUL 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t reg_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f >NUL 2>&1

:: QOS
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t reg_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "00000000" /f >NUL 2>&1
reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t reg_DWORD /d "0" /f >NUL 2>&1

:: Network Priorities
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t reg_DWORD /d "4" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t reg_DWORD /d "5" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t reg_DWORD /d "6" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t reg_DWORD /d "7" /f >NUL 2>&1

:: Enable The Network Adapter Onboard Processor
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t reg_DWORD /d "0" /f >NUL 2>&1

:: NIC Settings - credits: imbiriy
for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /v "*SpeedDuplex" /s ^| findstr  "HKEY"') do (
    for /f %%i in ('reg query "%%a" /v "*ReceiveBuffers" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*ReceiveBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*TransmitBuffers" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*TransmitBuffers" /t REG_SZ /d "1024" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*DeviceSleepOnDisconnect" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*EEE" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*ModernStandbyWoLMagicPacket" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*ModernStandbyWoLMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*SelectiveSuspend" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*WakeOnMagicPacket" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "*WakeOnPattern" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*WakeOnPattern" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "AutoPowerSaveModeEnabled" ^| findstr "HKEY"') do (
        reg add "%%i" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EEELinkAdvertisement" ^| findstr "HKEY"') do (
        reg add "%%i" /v "EEELinkAdvertisement" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EeePhyEnable" ^| findstr "HKEY"') do (
        reg add "%%i" /v "EeePhyEnable" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EnableGreenEthernet" ^| findstr "HKEY"') do (
        reg add "%%i" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "EnableModernStandby" ^| findstr "HKEY"') do (
        reg add "%%i" /v "EnableModernStandby" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "GigaLite" ^| findstr "HKEY"') do (
        reg add "%%i" /v "GigaLite" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "PowerDownPll" ^| findstr "HKEY"') do (
        reg add "%%i" /v "PowerDownPll" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "PowerSavingMode" ^| findstr "HKEY"') do (
        reg add "%%i" /v "PowerSavingMode" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "ReduceSpeedOnPowerDown" ^| findstr "HKEY"') do (
        reg add "%%i" /v "ReduceSpeedOnPowerDown" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "S5WakeOnLan" ^| findstr "HKEY"') do (
        reg add "%%i" /v "S5WakeOnLan" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "SavePowerNowEnabled" ^| findstr "HKEY"') do (
        reg add "%%i" /v "SavePowerNowEnabled" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "ULPMode" ^| findstr "HKEY"') do (
        reg add "%%i" /v "ULPMode" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeOnLink" ^| findstr "HKEY"') do (
        reg add "%%i" /v "WakeOnLink" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeOnSlot" ^| findstr "HKEY"') do (
        reg add "%%i" /v "WakeOnSlot" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeUpModeCap" ^| findstr "HKEY"') do (
        reg add "%%i" /v "WakeUpModeCap" /t REG_SZ /d "0" /f >nul 2>&1
    )
    for /f %%i in ('reg query "%%a" /v "WakeUpModeCap" ^| findstr "HKEY"') do (
        reg add "%%i" /v "PnPCapabilities" /t REG_SZ /d "24" /f >nul 2>&1
    )
) >nul 2>&1

:: Disable power saving on "Plug and Play" devices
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do ( 
			reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "PnPCapabilities" /t REG_DWORD /d "24" /f > NUL 2>&1
		)
	)
)
echo %c_green%Done.

::::::::::::::::
:: GPU Tweaks ::
::::::::::::::::

title Do not close this window - [63/66] Tweaking more things
echo Tweaking more things...
:: DXKrnl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DpiMapIommuContiguous /t REG_DWORD /d 1 /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "CreateGdiPrimaryOnSlaveGPU" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DriverSupportsCddDwmInterop" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncDxAccess" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncGPUAccess" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCreateSwapChain" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkFreeGpuVirtualAddress" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkOpenSwapChain" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkShareSwapChainObject" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent2" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "SwapChainBackBuffer" /t REG_DWORD /d "1" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "TdrResetFromTimeoutAsync" /t REG_DWORD /d "1" /f >NUL 2>&1

::::::::::::::
:: MSI Mode ::
::::::::::::::

:: Set for the graphics card.
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f >NUL 2>&1
for /f %%a in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t reg_DWORD /d "1" /f >NUL 2>&1
)

:: Set for USB / portable devices.
for /f %%a in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t reg_DWORD /d "1" /f >NUL 2>&1
)

:: Set for networking devices.
for /f %%a in ('wmic path Win32_NetworkAdapter get PNPDeviceID ^| findstr /L "VEN_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%a\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t reg_DWORD /d "1" /f >NUL 2>&1
)
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI"^| findstr "HKEY"') do (
	for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do reg delete "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >NUL 2>&1
)
echo %c_green%Done.

:: Disable Power Saving
title Do not close this window - [64/66] Tweaking more power configurations
echo %c_cyan%Tweaking more power configurations...
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t reg_DWORD /d "0" /f >NUL 2>&1
for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v "StorageD3InModernStandby" /t	reg_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t	reg_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t	reg_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t	reg_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t	reg_DWORD /d "1" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t	reg_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t	reg_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t	reg_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t	reg_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t	reg_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v "IdlePowerMode" /t	reg_DWORD /d "0" /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Services\pci\Parameters" /v "ASPMOptOut" /t	reg_DWORD /d "1" /f
)

:: Deleting default, unnecessery powerplans..
if /i "%isDuck" equ "1" (
    echo Deleting default, unnecessery powerplans..
    powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
    powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61
)
echo %c_green%Done.

title Do not close this window - [65/66] Configuring services
if %isDuck% equ 1 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\3ware" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\ADP80XX" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMDPPM" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\IntelPPM" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AmdK8" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppVClient" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\arcsas" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\AsyncMac" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\bindflt" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\buttonconverter" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\CAD" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\cdfs" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\CimFS" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\cnghwassist" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\CompositeBus" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dfsc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DispBrokerDesktopSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\edgeupdate" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\edgeupdatem" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\ErrDev" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\fdc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\fdPHost" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\FDResPub" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\flpydisk" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\icssvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvraid" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\PEAUTH" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\PhoneSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVE" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\sfloppy" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SiSRaid2" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SiSRaid4" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SmsRouter" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\sppsvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SSDPSRV" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Telemetry" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\udfs" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\umbus" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\VerifierExt" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\vsmraid" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSTXRAID" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WarpJITSvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcnfs" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WindowsTrustedRTProxy" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WPDBusEnum" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f
)

title Do not close this window - [66/66] Final tweaks
echo %c_cyan%Tweaking last things...

:: Processor
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v DistanceThresholdInDIPS /t REG_DWORD /d 00000028 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v MagnetismDelayInMilliseconds /t REG_DWORD /d 00000032 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v MagnetismUpdateIntervalInMilliseconds /t REG_DWORD /d 00000010 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v AttractionRectInsetInDIPS /t REG_DWORD /d 00000005 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v IRRemoteNavigationDelta /t REG_DWORD /d 1 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v CursorSensitivity /t REG_DWORD /d 00002710 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v VelocityInDIPSPerSecond /t REG_DWORD /d 00000168 /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v CursorUpdateInterval /t REG_DWORD /d 1 /f >NUL 2>&1

:: Valorant DSCP policies
:: The tweaks below can work for any game/exe, but Valorant has the best performance boost.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Version" /t REG_SZ /d "1.0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Application Name" /t REG_SZ /d "valorant.exe" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Protocol" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local Port" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote Port" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "DSCP Value" /t REG_SZ /d "46" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Throttle Rate" /t REG_SZ /d "-1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Version" /t REG_SZ /d "1.0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Application Name" /t REG_SZ /d "VALORANT-Win64-Shipping.exe" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Protocol" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local Port" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote Port" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "DSCP Value" /t REG_SZ /d "46" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT" /v "Throttle Rate" /t REG_SZ /d "-1" /f

:::::::::::::::::::::::::
:: Boot configuration. ::
:::::::::::::::::::::::::

:: Disable NX
bcdedit /deletevalue nx

:: Disable HPET
bcdedit /deletevalue useplatformclock

:: Disable dynamic tick (mostly for laptops, laptops use this feature for power saving)
bcdedit /set disabledynamictick yes

:: Use synthetic timers
bcdedit /set useplatformtick yes

:: Dualboot timer (doesn't impact the performance)
bcdedit /timeout 10

:: Disable the boot-screen animation
bcdedit /set bootux disabled

:: Legacy Windows 7 boot menu policy
bcdedit /set bootmenupolicy Legacy

:: Disable Hyper virtualization
bcdedit /set hypervisorlaunchtype off

:: Disable the Trusted Platform Module (TPM)
bcdedit /set tpmbootentropy ForceDisable

if /i "%isDuck" equ "1" (
    :: Set the DuckOS' name to DuckOS.. so it can be easily identified when dualbooting.
    bcdedit /set {current} description DuckOS
    :: Disable boot logo
    bcdedit /set {globalsettings} custom:16000067 true
    :: Disable spinning dots
    bcdedit /set {globalsettings} custom:16000068 true
    :: Disable boot messages
    bcdedit /set {globalsettings} custom:16000069 true
)

:: Disable Recovery
if /i "%isDuck" equ "1" (
    if exist %windir%\System32\reagentc.exe reagentc.exe /disable
    bcdedit /set {current} recoveryenabled no
) else (
    echo %c_red%Disabling recovery might be unsafe for your system, skipping.
)

:: Disable Devices with DevManView
if /i "%isDuck" equ "1" (
    cd /d %windir%\DuckOS_Modules
    if exist %windir%\DuckOS_Modules\devmanview.exe (
        devmanview /disable "Composite Bus Enumerator"
        devmanview /disable "System Speaker" MemoryDiagnostic
        devmanview /disable "System Timer"
        devmanview /disable "UMBus Root Bus Enumerator"
        devmanview /disable "Microsoft System Management BIOS Driver"
        devmanview /disable "High Precision Event Timer"
        devmanview /disable "PCI Encryption/Decryption Controller"
        devmanview /disable "AMD PSP"
        devmanview /disable "Intel SMBus"
        devmanview /disable "Intel Management Engine"
        devmanview /disable "PCI Memory Controller"
        devmanview /disable "PCI standard RAM Controller"
        devmanview /disable "Microsoft Kernel Debug Network Adapter"
        devmanview /disable "SM Bus Controller"
        devmanview /disable "NDIS Virtual Network Adapter Enumerator"
        devmanview /disable "Numeric Data Processor"
        devmanview /disable "Microsoft RRAS Root Enumerator"
        devmanview /disable "WAN Miniport (IKEv2)"
        devmanview /disable "WAN Miniport (IP)"
        devmanview /disable "WAN Miniport (IPv6)"
        devmanview /disable "WAN Miniport (L2TP)"
        devmanview /disable "WAN Miniport (Network Monitor)"
        devmanview /disable "WAN Miniport (PPPOE)"
        devmanview /disable "WAN Miniport (PPTP)"
        devmanview /disable "WAN Miniport (SSTP)"
    )
)
if not exist %windir%\DuckOS_Modules\devmanview.exe ( echo $ DevManView is missing, cannot disable unnecessary devices in Device Management.. )

::::::::::::::
:: Clean up ::
::::::::::::::
 
:: Misc Tweaks
lodctr /r >nul 2>&1

:: Disable USB Autorun/play
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f

:: Disable Network Navigation pane in file explorer
reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2962489444 /f

:: tokens arg breaks path to just \Device instead of \Device Parameters
:: Disable Power savings on drives
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
powershell -NoProfile -Command "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $False; $p.psbase.put()}}}" >nul 2>nul

:: Windows Server Update Client ID
sc stop wuauserv >nul 2>nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientId" /t REG_SZ /d "00000000-0000-0000-0000-000000000000" /f

:: Disable hibernation completely..
powercfg -h off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t reg_DWORD /d "0" /f >NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t reg_DWORD /d "0" /f >NUL 2>&1

:: Set Hibernation type to Reduced
powercfg /h /type reduced

:: Disable/Configure windows updates
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUAsDefaultShutdownOption" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "	DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AUPowerManagement" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAUShutdownOption" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableDualScan" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "EnableFeaturedSoftware" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f
reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "AllowAutoWindowsUpdateDownloadOverMeteredNetwork" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "BranchReadinessLevel" /t REG_DWORD /d "20" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "4" /f

:: Disable Speech Model Updates
reg add "HKLM\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f

:: Data Queue Sizes -- for both the keyboard and the mouse!
reg add "HKLM\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "25" /f
reg add "HKLM\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "25" /f

:: File Explorer settings..
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f

:: Disable tracking of application startups
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f

:: Disable "Aero Shake"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f

:: Disable Text/Ink/Handwriting Telemetry
reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f

:: Disable Sending KMS client activation data to Microsoft automatically.. -- you tryna pirate?? damn??
reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f

:: Disable Settings Sync
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f

:: Disable Feedback
%currentuser% reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f

:: Hide "Meet Now" button. It's crap if we wanna be honest.
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f

:: Disable Location Tracking
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f

:: Advertising Info
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f

:: Delete the "Readyboost" tab from external drives.
reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" /f >nul 2>nul

:: Disable Windows Media Player DRM Online Access
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f

:: Clear page file at shutdown
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /d "1" /t REG_DWORD /f

:: Show all tasks on the "Control Panel", credits: Tenforums
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "InfoTip" /t REG_SZ /d "View list of all Control Panel tasks" /f
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "System.ControlPanel.Category" /t REG_SZ /d "5" /f
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\imageres.dll,-27" /f
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\Shell\Open\Command" /ve /t REG_SZ /d "explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f

:: Disable Fault Tolerant Heap
:: Link with explanations: https://docs.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap
:: Works for Windows 7 and up!
reg add "HKLM\Software\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f

:: GameBar/FSE Settings
:: Disables Win+G shortcut
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f

:: Disable game mode
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f

:: Disable DWM's AeroPeek
:: Source: Winaero Tweaker
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f

:: Add batch (command prompt) files to the right-click "new file" menu
reg add "HKLM\Software\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%windir%\System32\acppage.dll,-6002" /f
reg add "HKLM\Software\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

:: Add registry files to the right-click "new file" menu
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@%windir%\regedit.exe,-309" /f
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f

:: "Merge as TrustedInstaller" for registry files
if /i "%isDuck" equ "1" (
    reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge as TrustedInstaller" /f
    reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f
    reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "%windir%\DuckOS_modules\nsudo.exe -U:T -P:E reg import "%%1"" /f
)

:: Disable Bluetooth
echo %c_red%Disabling Bluetooth...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\BluetoothUserService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
sc config BluetoothUserService start=disabled >nul 2>&1
sc config BTAGService start=disabled >nul 2>&1
sc config BthAvctpSvc start=disabled >nul 2>&1
sc config bthserv start=disabled >nul 2>&1

:: Disable HPET and Synthethic Timer
echo %c_red%Disabling HPET and Synthethic Timer...
powershell -MTA -Command "Get-PnpDevice | Where-Object { $_.InstanceId -like 'ACPI\PNP0103\2&daba3ff&*' } | Disable-PnpDevice -Confirm:$false"
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1

::::::::::::
:: Finish ::
::::::::::::

:: Do not reduce sounds while in a call..
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f

:: ? (google it)
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" /v "EnabledState" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" /v "EnabledState" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f >nul 2>&1
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" /v "BagMRU Size" /t REG_DWORD /d "1" /f >nul 2>&1

:: Switch from Public To Private firewall..
powershell -NoProfile "$net=get-netconnectionprofile; Set-NetConnectionProfile -Name $net.Name -NetworkCategory Private" >nul 2>&1
echo %c_green%Done, finalizing...

:: Make the post script not run every time you start the computer again anymore, since tweaking is complete...
if "%isDuck%" equ "1" ( reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" /v "*DuckOS Post Install Tweaks" /f )

:: Cancel any pending shutdowns, and restart in 2 seconds.. [with force option]
:: If the argument -noRestart is selected, then we will restart..
shutdown /a

if /i "%noRestart%" equ "0" ( shutdown /r /t 0 /f ) else (
    echo $ You selected to not restart. Please restart as soon as possible to apply changes!
    echo $ Quitting soon in 8 seconds..
    timeout 8 /nobreak
)
exit

:MsgBox [Prompt] [Type] [Title]
    setlocal enableextensions
    set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
    >"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
    set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
    endlocal & exit /b %exitCode%


:noArgs
color 0a
title Hold up!
cls 
echo %c_red%██╗  ██╗ ██████╗ ██╗     ██████╗     ██╗   ██╗██████╗ ██╗
echo %c_red%██║  ██║██╔═══██╗██║     ██╔══██╗    ██║   ██║██╔══██╗██║
echo %c_red%███████║██║   ██║██║     ██║  ██║    ██║   ██║██████╔╝██║
echo %c_red%██╔══██║██║   ██║██║     ██║  ██║    ██║   ██║██╔═══╝ ╚═╝
echo %c_red%██║  ██║╚██████╔╝███████╗██████╔╝    ╚██████╔╝██║     ██╗
echo %c_red%╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═════╝      ╚═════╝ ╚═╝     ╚═╝
echo.
echo %c_red%$ No CMDLine args were passed. The script doesn't know what to do.
echo.
echo %c_cyan%$ 1 - Tweak the computer only
echo %c_cyan%$ 2 - Turn off automatic restarting after the tweaks are done.
echo %c_cyan%$ 3 - Launch the script in debug mode
echo %c_cyan%$ 4 - Exit the script without making any changes to your device
:askAgain
set /p choice="Your choice: "
if %choice% equ 1 ( goto :tweaks ) else (
    echo.
    echo $ Invalid choice. && goto askAgain
)
if %choice% equ 2 (
    set noRestart=1
    cls
    goto begin
) else (
    echo.
    echo %c_red%$ Invalid choice. && goto askAgain
)
if %choice% equ 3 (
    set debugMode=1
    cls
    goto begin
) else (
    echo.
    echo %c_red%$ Invalid choice. && goto askAgain
)
if %choice% equ 4 (
    cls
    echo $ You've chosen to exit the script. You may relaunch the script at any time.
    echo Press any key to exit. & pause >nul
    exit
) else (
    echo.
    echo %c_red%$ Invalid choice. && goto askAgain
)

:TrustedInstaller
echo %c_gold%$ Relaunching as TrustedInstaller...
set nsudo=%windir%\DuckOS_Modules\nsudo.exe

if /i exist %nsudo% ( %nsudo% -P:E -U:T "%~f0" -onlyTweak %* && exit )

if not exist %nsudo% (
    cls
    color cf
    echo $ NSudo doesn't exist in the default directory you specified! The script can't run with it's full potential.
    :ask_NSUDO
    set /p nsudo=Please enter the NSudo path:
    if /i not exist "%nsudo%" goto :ask_NSUDO
    if /i exist "%nsudo%" ( "%nsudo%" -P:E -U:T "%~f0" -onlyTweak %* && exit )
    break
)

:updateDetected
if exist "%TEMP%\type.txt" del /f /q "%TEMP%\type.txt" >NUL
if exist "%windir%\system32\curl.exe" ( curl --progress-bar https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/changelog_type.txt -o "%TEMP%\type.txt" ) else ( powershell iwr -Method Get -Uri https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/changelog_type.txt -OutFile "%TEMP%\type.txt" )

::::::::::::::::::::::::::::::::::::::::::::::
:: Check if necessery variables aren't set  ::
::::::::::::::::::::::::::::::::::::::::::::::

:: Check if the version is empty..
if "%version%" equ "" ( break && goto :noArgs )

:: Check if the changes is empty..
if "%changes%" equ "" ( break && goto :noArgs )

:: The "type" of the new versions can be:
::  1. bug_fixes
::  2. feature_updates
::  3. os_update

:: Check for bug_fixes
findstr /i "bug_fixes" %temp%\type.txt
if errorlevel 0 ( set changes=Fixed bugs, which makes your experience better. Recommended to apply the tweaks. )

:: Check for feature_updates
findstr /i "feature_update" %temp%\type.txt
if errorlevel 0 ( set changes=Something NEW has been added. Recommended to apply the tweaks, might give performance. )

:: Check for os_updates
findstr /i "os_update" %temp%\type.txt
if errorlevel 0 ( set changes=Something were changed in the operating system. You aren't required to apply the tweaks. )

:: Check for profile picture/wallpaper updates
findstr /i "img_updates" %temp%\type.txt
if errorlevel 0 ( set changes=The wallpaper/profile pictures were changed. )

:: The "Update found" screen.
color 0e
title Woah! New update detected.
cls
chcp 65001 >nul
echo %c_cyan%██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗    ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗ 
echo %c_cyan%██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗
echo %c_cyan%██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗      █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║  ██║
echo %c_cyan%██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝      ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║  ██║
echo %c_cyan%╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗    ██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝
echo %c_cyan% ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ 
echo.
echo %c_white%=================================================================================================
echo.
echo %c_white%$ Local Version: %c_red%%version%
echo %c_white%$ Version from the internet: %c_green%%1
echo.
echo %c_cyan%$ What's changed: %c_green%%changes%
echo %c_white%================================================================================================
echo.
echo %c_cyan%$ Would you like to %c_red%update? [Y/N]
choice /n >nul
if errorlevel 1 (
    echo %c_green%Updating the script..
    if exist %TEMP%\Post-script_ver.txt del /f /q %TEMP%\Post-script_ver.txt
    if exist %TEMP%\type.txt del /f /q %TEMP%\type.txt
    if exist "%windir%\system32\curl.exe" ( curl -L --progress-bar https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/DuckOS_Modules/DuckOS-post_script.bat -o "%~f0" ) else ( powershell -mta iwr -Method Get -Uri https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/DuckOS_Modules/DuckOS-post_script.bat -OutFile "%~f0" )
    call "%~f0" %UpdateArgs%
) else (
    if exist %TEMP%\Post-script_ver.txt del /f /q %TEMP%\Post-script_ver.txt
    if exist %TEMP%\type.txt del /f /q %TEMP%\type.txt
    goto :noArgs
)

:noUpdates
color 0e
cls
title No updates detected :^(
chcp 65001 >nul
echo %c_red%███╗   ██╗ ██████╗     ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗███████╗
echo %c_red%████╗  ██║██╔═══██╗    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔════╝
echo %c_red%██╔██╗ ██║██║   ██║    ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  ███████╗
echo %c_red%██║╚██╗██║██║   ██║    ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  ╚════██║
echo %c_red%██║ ╚████║╚██████╔╝    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗███████║
echo %c_red%╚═╝  ╚═══╝ ╚═════╝      ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝
echo.
echo %c_gold%$ %c_green%No updates detected, you are up to date!
echo %c_gold%$ Current version: %c_green%%version%
echo.
if "%CFUExit%" equ "0" (
    echo %c_red%$ Press any key to quit.
    pause >nul
    exit
) else ( exit 0 )
