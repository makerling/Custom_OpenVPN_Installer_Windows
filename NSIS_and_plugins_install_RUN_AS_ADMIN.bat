@ECHO OFF

echo Checking to see if NSIS application is installed on your computer...
:Checking for existence of NSIS application if not give options for install
SET eightysix=0
SET noneightysix=0
SET NSISinstallDir=0
IF NOT EXIST "%programfiles(x86)%\NSIS" SET eightysix=2
IF NOT EXIST "%programfiles%\NSIS" SET noneightysix=3
SET /a added=%eightysix%+%noneightysix%
IF %added%==5 goto :NSISinstall
if %eightysix%==2 (set "NSISinstallDir=C:\Program Files\NSIS\Plugins") else (set "NSISinstallDir=C:\Program Files (x86)\NSIS\Plugins")
echo.
echo ...NSISinstallDir is: %NSISinstallDir%
echo.
goto :Plugins

:NSISinstall
echo.
set /P c=...NSIS has not been found on this computer. Are you ready to install it now [Y/N]?
IF /I "%c%" EQU "Y" GOTO :install
IF /I "%c%" EQU "N" GOTO :notnow
ECHO.
PAUSE

:install
echo. to
echo Opening NSIS setup... Please run this script again after NSIS to install the necessary Plugins. 
start "" "%~dp0source\nsis-3.0b3-setup.exe"
GOTO :end	

:notnow
ECHO.
ECHO NSIS application installer can be found in the "source" folder
ECHO.
GOTO :end
	
:Plugins
:Checking for existence of NSIS Plugins if not installed
echo Checking to see if Plugins installed...
echo.
IF NOT EXIST "%NSISinstallDir%\x86-unicode\ShellLink.dll" (goto :Plugininstall) else (echo ...plugins already installed, aborting.)
goto :end

:Plugininstall
set /P c=...the necessary NSIS plugins have not been found on this computer. Are you ready to install them now [Y/N]?
IF /I "%c%" EQU "Y" GOTO :Plugininstallnow
IF /I "%c%" EQU "N" GOTO :Pluginnotnow
ECHO.
goto :end

:Plugininstallnow
echo.
copy "%~dp0source\unicode\ShellLink.dll" "%NSISinstallDir%\x86-unicode\"
copy "%~dp0source\unicode\SelfDel.dll" "%NSISinstallDir%\x86-unicode\"
copy "%~dp0source\ansi\SelfDel.dll" "%NSISinstallDir%\x86-ansi\"
copy "%~dp0source\ansi\ShellLink.dll" "%NSISinstallDir%\x86-ansi\"
echo Plugins have finished installing
echo.
goto :end

:Pluginnotnow
ECHO.
ECHO To manually install the Plugins please move the following files into the following directories:
ECHO.
ECHO "source\unicode\ShellLink.dll" and "source\unicode\SelfDel.dll" into "%NSISinstallDir%\x86-unicode\"
ECHO.
ECHO "source\ansi\ShellLink.dll" and "source\ansi\SelfDel.dll" into "%NSISinstallDir%\x86-ansi\"
ECHO.
GOTO :end
	
:end
PAUSE
