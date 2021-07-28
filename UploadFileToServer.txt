function UploadFileToServer{
    try
    {
        #Reading ftp server url
        $ftpserverurl = Read-Host 'FTP Server URL without "ftp://"'
        $client = New-Object System.Net.Sockets.TcpClient($ftpserverurl, 21)
        $client.Close()

        #Reading credential inputs
        $username = Read-Host 'Username'
        $password = Read-Host 'Password'

        function UploadFile 
        {
            $Path = Read-Host 'Enter the path to the file you want to upload'
            if(Test-Path $Path){
    
                #Getting the file name from the path
                $filename = Split-Path $Path -Leaf
                #Setting ftp server url
                $remote_file = $ftpserverurl+'/'+$filename

                # create the FtpWebRequest and configure it
                $request = [Net.WebRequest]::Create('ftp://'+$remote_file)
                $request.Credentials =    New-Object System.Net.NetworkCredential($username, $password)
                $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile 

                #Creating file stream
                $fileStream = [System.IO.File]::OpenRead($Path)
                $ftpStream = $request.GetRequestStream()

                # reading the file stream for upload as a byte array
                $buffer = New-Object Byte[] 10240
                while (($read = $fileStream.Read($buffer, 0, $buffer.Length)) -gt 0)
                {
                    $ftpStream.Write($buffer, 0, $read)
                    $pct = ($fileStream.Position / $fileStream.Length)
    
                    #Displaying the current upload progress
                    Write-Progress ` -Activity "Uploading" -Status ("{0:P0} complete:" -f $pct) ` -PercentComplete ($pct * 100)
                }

                # Closing connection and releasing file from process
                $ftpStream.Dispose()
                $fileStream.Dispose()
                Write-Host "======================== Uploaded successfully! ========================" -ForegroundColor black -BackgroundColor green
                $check = Read-Host 'Do you want to upload another file? Y/N'
                if(($check -eq 'Y') -or ($check -eq 'y')){
                    UploadFile
                }
           }
           else{
                Write-Host "Invalid file path supplied!" -ForegroundColor white -BackgroundColor red
                Read-Host 'Press enter to continue'
                UploadFile
           }

        }
        UploadFile
    }
    catch
    {
        Write-Host "Connection failed: $($_.Exception.Message)" -ForegroundColor white -BackgroundColor red
        $check = Read-Host 'Do you want to try again? Y/N'
        if(($check -eq 'Y') -or ($check -eq 'y')){
            UploadFileToServer
        }
    }
}
UploadFileToServer