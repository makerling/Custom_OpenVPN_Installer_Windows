@ECHO OFF
:To capture variables inside of if statements
Setlocal EnableDelayedExpansion
ECHO.
ECHO.
ECHO. *****************************************************************
ECHO [%date% %time%] starting VPN installer script with minimal logging
ECHO.
:Variables
SET VPNconfigDownloadFolder=%USERPROFILE%\Downloads
:Current Working Directory of script: %~dp0
SET SevenZipFolder=%~dp0unixtools
:Find downloaded VPN config file in Downloads folder and turn into variable %VPNConfigtarFile%
FOR /F "delims=|" %%I IN ('DIR "%VPNconfigDownloadFolder%\*.tar" /B /O:D') DO SET VPNConfigtarFile=%%I

IF EXIST %VPNconfigDownloadFolder%\*.tar (
	
	ECHO Processing VPN Configuration Filename: "%VPNConfigtarFile%"
	ECHO.
	ECHO Checking to see if "%VPNConfigtarFile%" is a valid OpenVPN config file...
	:IF test to verify if tar file is really a VPN config file (had to Setlocal EnableDelayedExpansion - in order to make the VPNConfigtarFile variable expand
	"%SevenZipFolder%\tar.exe" -tf "%VPNconfigDownloadFolder%\%VPNConfigtarFile%" | findstr ovpn
	IF %errorlevel% EQU 0 ( 
		ECHO ...Yes! it is a valid OpenVPN config file
		ECHO.
		:Cleaning up old files in working directory (all are located in archived folder anyway)
		IF EXIST "*.exe" DEL "*.exe"
		IF EXIST "*.tar" DEL "*.tar"			
		IF EXIST "*.ovpn" DEL "*.ovpn"
		ECHO Moving .tar file to working directory
		MOVE /-y "%VPNconfigDownloadFolder%\%VPNConfigtarFile%" "%~dp0" 
		:Copy to archived_installers_configs
		ECHO Copying .tar file to "archived_installers_configs" folder
		COPY "%~dp0%VPNConfigtarFile%" "%~dp0archived_installers_configs\"
		:Untar (Unzip) VPN config file using 7z 
		ECHO.
		ECHO Extracting VPN configuration from .tar file...
		"%SevenZipFolder%\tar.exe" -xvf "%VPNConfigtarFile%" 
		ECHO ...was successfully extracted.
		:Find last created .ovpn file in working directory and turn into variable %NewestovpnFile%
		FOR /F "delims=|" %%I IN ('DIR "*.ovpn" /B /O:D') DO SET NewestovpnFile=%%I
		:Copy to archived_installers_configs directory of batch script
		ECHO.
		ECHO Copying .ovpn file to "archived_installers_configs" folder
		copy "!NewestovpnFile!" "%~dp0archived_installers_configs\" 
		:Generate variables for organization name and username from ovpn file
		ECHO.
		FOR /f "tokens=1,2,3 delims=_ " %%a IN ("!NewestovpnFile!") DO SET org=%%a&set user=%%b&set server=%%c
		ECHO The VPN Config's org is: "!org!" and user is: "!user!"
		:Capturing the filename of the source openvpn exe file
		FOR %%a in (source\open*x86_64.exe) DO SET SourceFileName64=%%~na
		FOR %%a in (source\open*i686.exe) DO SET SourceFileNamex86=%%~na
		
		:Checking for NSIS application location install "Program Files" or "Program Files (x86)"
		SET NSISinstallDir=0
		SET eightysix=0
		SET noneightysix=0
		IF NOT EXIST "%programfiles(x86)%\NSIS" SET eightysix=1
		IF NOT EXIST "%programfiles%\NSIS" SET noneightysix=1
		IF !eightysix! GTR 0 (set NSISinstallDir="%programfiles%\NSIS") ELSE (set NSISinstallDir="%programfiles(x86)%\NSIS\makensis.exe")
		ECHO.
		ECHO Finding NSIS install dir... it is: !NSISinstallDir!
		:Launching the NSIS script with variable to customize the installer and shortcut name
		ECHO Now starting the creation of VPN installer exe
		ECHO.
		ECHO ****************************
		!NSISinstallDir! /Doutput_exe="vpn-installer_!org!_!user!.exe" /Dconfig_name="!NewestovpnFile!" /Ddesktop_shortcut_name="Start_!org!_VPN" /Dsource_file_name_x86="!SourceFileNamex86!.exe" /Dsource_file_name_64="!SourceFileName64!.exe" NSIS_script.nsi
		ECHO ****************************
		ECHO.
		ECHO Copying VPN installer to "archived_installers_configs" folder
		IF EXIST "vpn*exe" COPY "vpn*exe" "%~dp0archived_installers_configs\"
		:Cleaning up
		IF EXIST "%~dp0%VPNConfigtarFile%" DEL "%~dp0%VPNConfigtarFile%"
		ECHO.
		goto :end
	) ELSE (
		ECHO tar file is not a VPN config file, aborting...
		goto :end
	)
) ELSE (
	:Cleaning up old files in working directory (all are located in archived folder anyway)
	IF EXIST "*.exe" DEL "*.exe"
	IF EXIST "*.tar" DEL "*.tar"			
	IF EXIST "*.ovpn" DEL "*.ovpn"
	ECHO There are no more VPN Config *.tar files to process. Ending...
)
GOTO :end

:end
ECHO.
ECHO [%date% %time%] finished VPN installer script
ECHO. *****************************************************************
ENDLOCAL
PAUSE