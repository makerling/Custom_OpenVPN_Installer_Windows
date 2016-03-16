# CustomVPN_Windows
A batch script to process user configurations from Pritunl VPN server. The batch script generates an .exe installer for an Windows OpenVPN client with config embedded.

Instructions:

1) First run the NSIS_and_plugins_install_RUN_AS_ADMIN.bat file. It will first start the install of the NSIS application. Choose the defaults during install. Next run the script again (make sure to run as Admin) and it will transfer the necessary plugins for NSIS.

2) Once the install has finished you'll need to set your default download location for your browser (by default the script chooses C:\Users\[username]\Downloads - you can change the selection by editing this variable: VPNconfigDownloadFolder. For example if you want to choose the Desktop folder change line 5 to look like:
SET VPNconfigDownloadFolder=%USERPROFILE%\Desktop)

3) Next download all the Pritunl .tar VPN config files you want to process. 

4) Start the '1_VPN_installer_creation_script.bat' script and it will automatically find and generate the .exe and .ovpn file in the current working directory (it will also copy the .exe, .ovpn. and .tar file to the archived_installers_configs folder)

5) The VPN_installer_creation_script.bat can be run consecutively and it will look for the .tar files until it doesn't find any more in the Downloads directory

6) If you choose to run the '1_VPN_installer_creation_script.bat' script, logging will be minimal. If you choose to run the '2_VPN_installer_creation_script_WITH_LOGGING' then the logging will be verbose. The log files will simply keep increasing in size. So, over time the log file can be deleted or archived somewhere else. 

Features:

The script uncompresses the Pritunl ovpn configuration from the .tar file. Then it embeds that config into the base OpenVPN installer. The script is configured to create a personalized VPN installer that will determine the client's architecture and install the appropriate OpenVPN executable (x86 or AMD64). 

The script generates an installer for the client which is mostly silent. It will create a customized 'Start VPN' shortcut on the desktop set to run the user's configuration file. The shortcut needs to have admin privileges in order to run OpenVPN properly. 


