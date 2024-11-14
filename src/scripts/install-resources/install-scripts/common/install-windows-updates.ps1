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

# Just so that it can be followed visually step by step
echo "Install Windows updated after sleeping 5"
Start-Sleep -Seconds 5

echo "Force TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

echo "Installing PSWindowsUpdate"
Install-Module -Name PSWindowsUpdate

Write-host "Search Windows Update for critical and security updates"
echo "Search Windows Update for critical and security updates and install them"
Install-WindowsUpdate -AcceptAll -AutoReboot -RootCategories "Critical Updates","Security Updates" -Verbose 4>&1

echo "Done installing windows updates, rebooting in 5 seconds"
Start-Sleep -Seconds 5
