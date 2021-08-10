$projectbasepath = Resolve-Path (Join-Path $pwd '..')
cd $projectbasepath

# Services for deployment
$Identity = Resolve-Path (Join-Path $pwd "\Services\FlexTest.IdentityManager\FlexTest.IdentityManager.csproj")
$FlexTestTestDev = Resolve-Path (Join-Path $pwd "\Services\FlexTest.TestDevelopment\FlexTest.TestDevelopment.csproj")
$FlexTestTestAdmin = Resolve-Path (Join-Path $pwd "\Services\FlexTest.TestAdministration\FlexTest.TestAdministration.csproj")
$FileStorage = Resolve-Path (Join-Path $pwd "\Services\FlexTest.FileStorage\FlexTest.FileStorage.csproj")

# Clients for deployment
$ControlRoom = Resolve-Path (Join-Path $pwd "\Clients\Web\FlexTest.ControlRoom\FlexTest.ControlRoom.csproj")
$OnlineTest = Resolve-Path (Join-Path $pwd "\Clients\Web\FlexTest.OnlineTest\FlexTest.OnlineTest.csproj")

# Release paths
$releasebasepath = "C:\Deployments\FlexTestApps"

# Default path to dotnet run time. You can change it if your is different.
$runtime = "C:\Program Files\dotnet\dotnet.exe"

# Clears previous releases if available in the releasebasepath
Remove-Item "$releasebasepath\*" -Recurse -Confirm:$true

# Publishing the selected projects
& $runtime publish $Identity -c release -o $releasebasepath"\Identity"
& $runtime publish $FlexTestTestDev -c release -o $releasebasepath"\FlexTestTestDev"
& $runtime publish $FlexTestTestAdmin -c release -o $releasebasepath"\FlexTestTestAdmin"
& $runtime publish $FileStorage -c release -o $releasebasepath"\FileStorage"

& $runtime publish $ControlRoom -c release -o $releasebasepath"\ControlRoom"
& $runtime publish $OnlineTest -c release -o $releasebasepath"\OnlineTest"

# Logging deployment information
function LogDeployment
{
  $datetime = Get-Date
  $filetext = "Last deployment was"+ " on " + $datetime
  $filetext | Out-File -filepath "C:\Deployments\FlexTestApps\DeploymentInfo.txt" -Append
}

LogDeployment
Write-Host "======================== Published successfully! ========================" -ForegroundColor black -BackgroundColor green
Read-Host "Press enter key to exit"