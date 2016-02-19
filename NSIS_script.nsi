# OpenVPN Application and Configuration Installer
# Based on: http://edoceo.com/creo/openvpn-config-installer
# @version $Id$
# Set Defaults
# Allows for /DOUTPUT_EXE=something.exe /CONFIG_NAME=config\file.cfg

!ifndef CONFIG_NAME
   !define CONFIG_NAME "sample.ovpn" 
!endif

!ifndef OUTPUT_EXE
    !define OUTPUT_EXE "vpn-installer.exe"
!endif

!ifndef DESKTOP_SHORTCUT_NAME
   !define DESKTOP_SHORTCUT_NAME "VPN_Start" 
!endif

!ifndef SOURCE_FILE_NAME
   !define SOURCE_FILE_NAME "VPN_Start" 
!endif

BrandingText "VPN Installer"
Caption "VPN Installer"
CompletedText "Finished"
Icon images\logo.ico
InstallColors 336699 333333
InstProgressFlags colored smooth
Name "VPN Installer"
OutFile ${OUTPUT_EXE}
RequestExecutionLevel admin
ShowInstDetails show
XPStyle off

Section ""

    MessageBox MB_YESNO "Are you ready to install the VPN Connection on your computer?" IDNO End
    SetOutPath $EXEDIR
    DetailPrint "Extracting OpenVPN $OUTDIR"
    # Bundle OpenVPN Installer
    File source\${SOURCE_FILE_NAME}
	ExecWait '"${SOURCE_FILE_NAME}" /S $0' 
    
    SetOutPath "$PROGRAMFILES32\OpenVPN\config"

    # Full contents of Config
    File /x .svn *.ovpn
		
	Delete "$EXEDIR\openvpn-install-2.3.8-I601-i686.exe"
	
	#Deleting original shortcut created by OpenVPN software so users aren't confused by them vs the Start_VPN shortcut
	Delete "C:\Users\Public\Desktop\OpenVPN GUI.lnk"
	Delete "C:\Documents and Settings\All Users\Desktop\OpenVPN GUI.lnk"
	
	#Creating customized shortcut for user which starts the OpenVPN software with their user config
	#This feature needs ShellLink plugin because it needs to run as Admin
	createShortCut "C:\Documents and Settings\All Users\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk" "$PROGRAMFILES32\OpenVPN\bin\openvpn-gui.exe" "--connect ${CONFIG_NAME} --show_balloon 2" "$PROGRAMFILES32\OpenVPN\icon.ico"
	ShellLink::SetRunAsAdministrator C:\Documents and Settings\All Users\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk
	Pop $0
	
	createShortCut "C:\Users\Public\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk" "$PROGRAMFILES32\OpenVPN\bin\openvpn-gui.exe" "--connect ${CONFIG_NAME} --show_balloon 2" "$PROGRAMFILES32\OpenVPN\icon.ico"
	ShellLink::SetRunAsAdministrator C:\Users\Public\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk
	Pop $0
	
	#deleting the installer for security sake - this feature relies on SelfDel plugin
	SelfDel::Del
		SetAutoClose true
	
	MessageBox MB_OK "To start the VPN Connection click on the ${DESKTOP_SHORTCUT_NAME} shortcut on your desktop"
	End:
SectionEnd