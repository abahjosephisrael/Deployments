# Deployments
To run the scripts,
- First rename the files to 'PublishFlexTest.ps1' and 'RunAllApps.ps1'
- Open PowerShell and change the script run policy using this command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" exactly the way it written.
- Open the scripts, make the changes you want, especially to publishbasepath so that you can publish to your choice folder.
- Run "PublishFlexTest" script.
- Modify the "appsettings.json" file for all the published applications.
- Run "RunAllApps" script.
-You're good to go.
