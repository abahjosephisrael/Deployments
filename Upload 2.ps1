$file = "C:\Users\JosephAbah\Downloads\SQLEXPR_x64_ENU.exe"
$ftpuri = "ftp://i:innotelligent@192.168.8.107/KMS_pico.zip"
$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftpuri)
$webclient.UploadFile($uri, $file)