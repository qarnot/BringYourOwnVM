# Source: https://github.com/rzander/mOSD/blob/master/Win10_Sources/sources/%24OEM%24/%24%24/Setup/Scripts/BootOOBE.ps1

# So that the rest of the text is not hidden by the progress window
echo "skip line 1"
echo "skip line 2"
echo "skip line 3"
echo "skip line 4"
echo "skip line 5"
echo "skip line 6"
echo "skip line 7"
echo "skip line 8"
echo "skip line 9"
echo "skip line 10"
echo "skip line 11"
echo "skip line 12"
echo "skip line 13"
echo "skip line 14"
echo "skip line 15"
echo "skip line 16"
echo "skip line 17"
echo "skip line 18"
echo "skip line 19"
echo "skip line 20"

# Equivalent of a set -e in a posix shell
$ErrorActionPreference="Stop"

#Set-Location $PSScriptRoot
Start-Sleep 3

echo "Search for running sysprep process and kill it if there is one"

Start-Sleep -Seconds 5
get-process sysprep -ea SilentlyContinue | stop-process -Force -ErrorAction SilentlyContinue

echo "done killing things"

#Cleanup

# YOANN: disable this as probably not useful for us?
#Remove-Item C:\Windows\Panther\unattend.xml -Force -ea SilentlyContinue
#Remove-Item C:\Windows\Setup\Scripts\init.ps1 -Recurse -Force -ea SilentlyContinue #Prevent loop after OOBE
#Rename-Item C:\Windows\Setup\Scripts\init2.ps1 init.ps1 -ea SilentlyContinue #Run Cleanup after OOBE

echo "re-killing stuff"  # don't know why...
get-process sysprep -ea SilentlyContinue | stop-process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

echo "Copy unattended-seal-oobe.xml"
Copy-Item F:\common\unattend-seal-oobe.xml C:\Windows\system32\sysprep\unattend.xml

echo "Launch sysprep, shutting down"
Start-Process -FilePath "C:\Windows\System32\Sysprep\sysprep.exe" -ArgumentList "/oobe /quiet /shutdown /unattend:C:\Windows\system32\sysprep\unattend.xml" -Wait

echo "SHOULD NOT BE HERE: done with sysprep, return in 5 seconds"
Start-Sleep 5

restart
