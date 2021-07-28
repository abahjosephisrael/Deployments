# Deployments
To run the scripts,
- First rename the files to 'PublishFlexTest.ps1' and 'RunAllApps.ps1'
- Open PowerShell and change the script run policy using this command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" exactly the way it written.
- Open the scripts, make the changes you want, especially to publishbasepath so that you can publish to your choice folder.
- Run "PublishFlexTest" script.
- Modify the "appsettings.json" file for all the published applications.
- Run "RunAllApps" script.
-You're good to go.
# FTP Server
To run this script:
- Right click on it and click on "Run with Powershell".
- Enter the ftp server url without "ftp://" e.g instead of "ftp://192.168.8.107" just type in "192.168.8.107" or "ftp.innotelligent.com" instead of "ftp://ftp.innotelligent.com".
- Enter the login credentials.
- Enter the absolute path to the file you want to upload.
- Wait for it to complete upload.
- You're done.