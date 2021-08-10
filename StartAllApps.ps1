$commands = @(
    [pscustomobject]@{port='5004';path='\FileStorage';app='FlexTest.FileStorage.dll'}
    [pscustomobject]@{port='5005';path='\Identity';app='FlexTest.IdentityManager.dll'}
    [pscustomobject]@{port='5006';path='\FlexTestTestDev';app='FlexTest.TestDevelopment.dll'}
    [pscustomobject]@{port='5007';path='\FlexTestTestAdmin';app='FlexTest.TestAdministration.dll'}
    [pscustomobject]@{port='5008';path='\ControlRoom';app='FlexTest.ControlRoom.dll'}
    [pscustomobject]@{port='5009';path='\OnlineTest';app='FlexTest.OnlineTest.dll'}
)


foreach($command in $commands)
{
    $applicationbasepath = 'C:\Deployments\FlexTestApps'+$command.path
    $env = '$env:ASPNETCORE_URLS=""""http://0.0.0.0:'+$command.port+'""""'
    $runtime = 'dotnet '+$command.app
    start-process powershell.exe -argument "-noexit -nologo -noprofile -Command cd $applicationbasepath; $env; $runtime" 
}