$download_link = "https://net-dcc.redmont.qarnot.net/windows/ndp48-x86-x64-allos-enu.exe"
$file_destination = "C:\Qarnot\ndp48-x86-x64-allos-enu.exe"

# So that the rest of the text is not hidden by the progress window
$line_number = 25 # Set number of line to skip

for($i=1; $i -le $line_number; $i++) 
{
    Write-host "skip line $i"
}

#Create Qarnot directory if not exist
if(!(Test-Path -Path "C:\Qarnot"))
{
   New-Item -Path "C:\Qarnot" -ItemType "directory"
}

Write-host "Force TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-host "Download all necessary files"
$ProgressPreference = 'SilentlyContinue' #add this to remove the download progress bar that limits the download speed
Invoke-WebRequest -Uri $download_link  -OutFile $file_destination

Write-host "Install .NET 4.8"
Start-Process -FilePath $file_destination -ArgumentList "/quiet /norestart" -Wait
Write-host "Installation done"