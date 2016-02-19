# CustomVPN_Windows
A batch script to process user configurations from Pritunl VPN server. The batch script generates an .exe installer for an Windows OpenVPN client with config embedded.

Instructions:

1) First run the NSIS_and_plugins_install_RUN_AS_ADMIN.bat file. It will first start the install of the NSIS application. Choose the defaults during install. Next run the script again (make sure to run as Admin) and it will transfer the necessary plugins for NSIS.

2) Once the install has finished you'll need to set your default download location for your browser (by default the script chooses C:\Users\%USER%\Downloads - you can change the selection by editing this variable: VPNconfigDownloadFolder)

3) Next download all the Pritunl .tar VPN config files you want to process. 

4) Start the VPN_installer_creation_script.bat script and it will generate the .exe and .ovpn file in the current working directory (it will also copy the .exe, .ovpn. and .tar file to the archived_installers_configs folder)

5) The VPN_installer_creation_script.bat can be consecutively and it will look for the .tar files until it doesn't find any more in the Downloads directory

