[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

#Create Qarnot directory if not exist
if(!(Test-Path -Path "C:\Qarnot"))
{
   New-Item -Path "C:\Qarnot" -ItemType "directory"
}

Write-host "Download python"
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.7.0/python-3.7.0.exe" -OutFile "C:/Qarnot/python-3.7.0.exe"

Write-host "Install python"
c:/Qarnot/python-3.7.0.exe /passive InstallAllUsers=1 PrependPath=1 Include_test=0 | Out-Null

Write-host "Completed, sleep 5 and continue"
Start-Sleep -Seconds 5