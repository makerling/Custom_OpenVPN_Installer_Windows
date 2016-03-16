# OpenVPN Application and Configuration Installer
# Based on: http://edoceo.com/creo/openvpn-config-installer
# @version $Id$
# Set Defaults
# Allows for /DOUTPUT_EXE=something.exe /CONFIG_NAME=config\file.cfg
!include x64.nsh

!ifndef CONFIG_NAME
   !define CONFIG_NAME "sample.ovpn" 
!endif

!ifndef OUTPUT_EXE
    !define OUTPUT_EXE "vpn-installer.exe"
!endif

!ifndef DESKTOP_SHORTCUT_NAME
   !define DESKTOP_SHORTCUT_NAME "VPN_Start" 
!endif

!ifndef SOURCE_FILE_NAME_x86
   !define SOURCE_FILE_NAME_x86 "openvpn-install-2.3.10-I602-i686.exe" 
!endif

!ifndef SOURCE_FILE_NAME_64
   !define SOURCE_FILE_NAME_64 "openvpn-install-2.3.10-I602-x86_64.exe" 
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

Section "64-bit" SEC0001

    MessageBox MB_YESNO "Are you ready to install the VPN Connection on your computer?" IDNO End
    SetOutPath $EXEDIR
	DetailPrint "Uninstalling old version x86"
	ExecWait '"$PROGRAMFILES32\OpenVPN\Uninstall.exe" /S $0' 
	
    DetailPrint "Extracting OpenVPN $OUTDIR"
    # Bundle OpenVPN Installer
    File source\${SOURCE_FILE_NAME_64}
	ExecWait '"${SOURCE_FILE_NAME_64}" /S /SELECT_SHORTCUTS=0 $0' 
    
    SetOutPath "$PROGRAMFILES64\OpenVPN\config"

    # Full contents of Config
    File /x .svn *.ovpn
		
	Delete "$EXEDIR\${SOURCE_FILE_NAME_64}"
	
	#Creating customized shortcut for user which starts the OpenVPN software with their user config
	#This feature needs ShellLink plugin because it needs to run as Admin
	
	createShortCut "C:\Users\Public\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk" "$PROGRAMFILES64\OpenVPN\bin\openvpn-gui.exe" "--connect ${CONFIG_NAME} --show_balloon 2" "$PROGRAMFILES64\OpenVPN\icon.ico"
	ShellLink::SetRunAsAdministrator C:\Users\Public\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk
	Pop $0
	
	#deleting the installer for security sake - this feature relies on SelfDel plugin
	SelfDel::Del
		SetAutoClose true
	
	MessageBox MB_OK "To start the VPN Connection click on the ${DESKTOP_SHORTCUT_NAME} shortcut on your desktop"
	End:
SectionEnd


Section "32-bit" SEC0000

    MessageBox MB_YESNO "Are you ready to install the VPN Connection on your computer?" IDNO End
    SetOutPath $EXEDIR
    DetailPrint "Extracting OpenVPN $OUTDIR"
    # Bundle OpenVPN Installer
    File source\${SOURCE_FILE_NAME_x86}
	ExecWait '"${SOURCE_FILE_NAME_x86}" /S /SELECT_SHORTCUTS=0 $0' 
    
    SetOutPath "$PROGRAMFILES32\OpenVPN\config"

    # Full contents of Config
    File /x .svn *.ovpn
		
	Delete "$EXEDIR\${SOURCE_FILE_NAME_x86}"
	
	#This feature needs ShellLink plugin because it needs to run as Admin
	#Creating customized shortcut for user which starts the OpenVPN software with their user config
	
	createShortCut "C:\Users\Public\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk" "$PROGRAMFILES32\OpenVPN\bin\openvpn-gui.exe" "--connect ${CONFIG_NAME} --show_balloon 2" "$PROGRAMFILES32\OpenVPN\icon.ico"
	ShellLink::SetRunAsAdministrator C:\Users\Public\Desktop\${DESKTOP_SHORTCUT_NAME}.lnk
	Pop $0
	
	#deleting the installer for security sake - this feature relies on SelfDel plugin
	SelfDel::Del
		SetAutoClose true
	
	MessageBox MB_OK "To start the VPN Connection click on the ${DESKTOP_SHORTCUT_NAME} shortcut on your desktop"
	End:
SectionEnd

Function .onInit
  #Determine the bitness of the OS and enable the correct section
  ${If} ${RunningX64}
    SectionSetFlags ${SEC0000}  ${SECTION_OFF}
    SectionSetFlags ${SEC0001}  ${SF_SELECTED}
  ${Else}
    SectionSetFlags ${SEC0001}  ${SECTION_OFF}
    SectionSetFlags ${SEC0000}  ${SF_SELECTED}
  ${EndIf}
FunctionEnd 
 
