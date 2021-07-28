#Reading inputs
$ftpserverurl = Read-Host 'FTP Server URL'
$username = Read-Host 'Username'
$password = Read-Host 'Password'
$local_file = Read-Host 'Enter the path to the file you want to upload'

#Getting the file name from the path
$filename = Split-Path $local_file -Leaf
$remote_file = $ftpserverurl+'/'+$filename

# create the FtpWebRequest and configure it
$ftprequest = [System.Net.FtpWebRequest]::Create("$remote_file")
$ftprequest = [System.Net.FtpWebRequest]$ftprequest
$ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$ftprequest.Credentials = new-object System.Net.NetworkCredential($username, $password)
$ftprequest.UseBinary = $true
$ftprequest.UsePassive = $true

# read in the file to upload as a byte array
$filecontent = gc -en byte $local_file
$ftprequest.ContentLength = $filecontent.Length

# get the request stream, and write the bytes into it
$run = $ftprequest.GetRequestStream()
Write-Host -Object "Uploading $filename..."-ForegroundColor black -BackgroundColor yellow;
$run.Write($filecontent, 0, $filecontent.Length)
Write-Host "======================== Uploaded successfully! ========================" -ForegroundColor black -BackgroundColor green

# Closing connection and releasing file from process
$run.Close()
$run.Dispose()