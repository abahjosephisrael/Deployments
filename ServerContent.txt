$username='i'
$password='innotelligent'
$ftp='ftp://192.168.8.107'
$subfolder='/'

$ftpuri = $ftp + $subfolder
$uri=[system.URI] $ftpuri
$ftprequest=[system.net.ftpwebrequest]::Create($uri)
$ftprequest.Credentials=New-Object System.Net.NetworkCredential($username,$password)
$ftprequest.Method=[system.net.WebRequestMethods+ftp]::ListDirectory
$response=$ftprequest.GetResponse()
$strm=$response.GetResponseStream()
$reader=New-Object System.IO.StreamReader($strm,'UTF-8')
$list=$reader.ReadToEnd()
$lines=$list.Split("`n")
return $lines


#$local_file = "C:\Users\JosephAbah\Desktop\Deployments.zip"
#$remote_file = "ftp://192.168.8.107/Deployments3.zip"
#C:\Users\JosephAbah\Downloads\SQLEXPR_x64_ENU.exe