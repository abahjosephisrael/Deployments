
        

        function DeleteFolder($url, $credentials)
        {
            $listRequest = [Net.WebRequest]::Create($url)
            $listRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
            $listRequest.Credentials = $credentials

            $lines = New-Object System.Collections.ArrayList

            $listResponse = $listRequest.GetResponse()
            $listStream = $listResponse.GetResponseStream()
            $listReader = New-Object System.IO.StreamReader($listStream)
            while (!$listReader.EndOfStream)
            {
                $line = $listReader.ReadLine()
                $lines.Add($line) | Out-Null
            }
            $listReader.Dispose()
            $listStream.Dispose()
            $listResponse.Dispose()

            foreach ($line in $lines)
            {
                $tokens = $line.Split(" ", 9, [StringSplitOptions]::RemoveEmptyEntries)
                $name = $tokens[8]
                $permissions = $tokens[0]

                $fileUrl = ($url + $name)

                if ($permissions[0] -eq 'd')
                {
                    DeleteFolder ($fileUrl + "/") $credentials
                }
                else
                {
                    Write-Host "Deleting file $name"
                    $deleteRequest = [Net.WebRequest]::Create($fileUrl)
                    $deleteRequest.Credentials = $credentials
                    $deleteRequest.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
                    $deleteRequest.GetResponse() | Out-Null
                }
            }

            Write-Host "Deleting folder"
            $deleteRequest = [Net.WebRequest]::Create($url)
            $deleteRequest.Credentials = $credentials
            $deleteRequest.Method = [System.Net.WebRequestMethods+Ftp]::RemoveDirectory
            $deleteRequest.GetResponse() | Out-Null
        }





Write-Host "Folders and sub folders already exist!" -ForegroundColor white -BackgroundColor red
$check = Read-Host 'Do you want to replace them? Y/N'
if(($check -eq 'Y') -or ($check -eq 'y')){
                                 
    #$url = $ftpserverurl+'/'+$folder;
    #$credentials = New-Object System.Net.NetworkCredential($username, $password)
    #DeleteFolder $url $credentials
}

