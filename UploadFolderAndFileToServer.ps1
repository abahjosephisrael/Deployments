function UploadFileToServer{

    try
    {
        #Reading ftp server url
        $ftpserverurl = Read-Host 'FTP Server URL without "ftp://"'
        #Validating server address
        $client = New-Object System.Net.Sockets.TcpClient($ftpserverurl, 21)
        $client.Close()

        #Reading credential inputs
        $username = Read-Host 'Username'
        $password = Read-Host 'Password'

        function UploadFile 
        {

            try
            {
                $Path = Read-Host 'Enter the path to the file you want to upload'

                if(Test-Path $Path)
                {
    
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
                $check = Read-Host 'Do you want to upload another thing? Y/N'
                if(($check -eq 'Y') -or ($check -eq 'y')){
                    TypeOfUpload
                }
           }
            }
            catch
            {
                Write-Host "Invalid file path supplied! $($_.Exception.Message)" -ForegroundColor white -BackgroundColor red
                UploadFile
            }

        }

        


        function UploadFolder
        {
        
            try
            {
                $ftpserverurl = 'ftp://'+$ftpserverurl

                #Directory to upload content
                $UploadFolder = Read-Host "Enter the path to the folder you want to upload it's content"

                # create the FtpWebRequest and configure it
                $webclient = New-Object System.Net.WebClient 
                $webclient.Credentials = New-Object System.Net.NetworkCredential($username,$password)  
 
                $SrcEntries = Get-ChildItem $UploadFolder -Recurse
                $Srcfolders = $SrcEntries | Where-Object{$_.PSIsContainer}
                $SrcFiles = $SrcEntries | Where-Object{!$_.PSIsContainer}

                # Create FTP Directory/SubDirectory If Needed - Start
                foreach($folder in $Srcfolders)
                {    
                    $SrcFolderPath = $UploadFolder  -replace "\\","\\" -replace "\:","\:"   
                    $DesFolder = $folder.Fullname -replace $SrcFolderPath,$ftpserverurl
                    $DesFolder = $DesFolder -replace "\\", "/"
                    # Write-Output $DesFolder
 
                    try
                    {
                        $makeDirectory = [System.Net.WebRequest]::Create($DesFolder);
                        $makeDirectory.Credentials = New-Object System.Net.NetworkCredential($username,$password);
                        $makeDirectory.Method = [System.Net.WebRequestMethods+FTP]::MakeDirectory;
                        $makeDirectory.GetResponse();
                        #folder created successfully
                        Write-Host "======================== Folders created successfully! ========================" -ForegroundColor black -BackgroundColor green
                    }
                    catch [Net.WebException]
                    {
                        try 
                        {
                            #if there was an error returned, check if folder already existed on server
                            $checkDirectory = [System.Net.WebRequest]::Create($DesFolder);
                            $checkDirectory.Credentials = New-Object System.Net.NetworkCredential($username,$password);
                            $checkDirectory.Method = [System.Net.WebRequestMethods+FTP]::PrintWorkingDirectory;
                            $response = $checkDirectory.GetResponse();
                            
                            #folder already exists!
                            
                        }
                        catch [Net.WebException] {
                        #if the folder didn't exist
                        }
                    }
                }
                # Create FTP Directory/SubDirectory If Needed - Stop
 
                # Upload Files - Start
                foreach($entry in $SrcFiles)
                {
                    $counter = 1
                    $SrcFullname = $entry.fullname
                    $SrcName = $entry.Name
                    $SrcFilePath = $UploadFolder -replace "\\","\\" -replace "\:","\:"
                    $DesFile = $SrcFullname -replace $SrcFilePath,$ftpserverurl
                    $DesFile = $DesFile -replace "\\", "/"
                    
                    # Write-Output $DesFile
                    $uri = New-Object System.Uri($DesFile) 
                    $webclient.UploadFile($uri, $SrcFullname)
                    
                    #Displaying the current upload progress
                    Write-Progress ` -Activity "Uploading" -Status ("{0:P0} complete:" -f $counter) ` -PercentComplete ($counter * 100)
                    $counter = $counter + 1
                }
                # Upload Files - Stop
                Write-Host ""
                Write-Host "======================== Contents uploaded successfully! ========================" -ForegroundColor black -BackgroundColor green
                $check = Read-Host 'Do you want to upload another thing? Y/N'
                if(($check -eq 'Y') -or ($check -eq 'y')){
                    TypeOfUpload
                }
            }
            catch
            {
                Write-Host $($_.Exception.Message) -ForegroundColor white -BackgroundColor red
                UploadFolder
            }
        }


        function TypeOfUpload
        {
            $check = Read-Host 'What do you want to upload? "F" - Single File, "C" - Folder Content'
            if(($check -eq 'F') -or ($check -eq 'f')){
                UploadFile
            }
            elseif(($check -eq 'C') -or ($check -eq 'c')){
                UploadFolder
            }
            else{
                Write-Host 'Invalid option!' -ForegroundColor White -BackgroundColor Red
                TypeOfUpload
            }
        }
        
        TypeOfUpload


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