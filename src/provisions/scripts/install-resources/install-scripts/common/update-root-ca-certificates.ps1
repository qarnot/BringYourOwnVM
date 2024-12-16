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

Write-Host "Updating root CA after sleeping 5 seconds"
Start-Sleep 5

# Just so that it can be followed visually step by step
Start-Sleep -Seconds 5

echo "Force TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

md C:\temp\certs

Write-Host "Getting root certificates from Windows Update"
CertUtil -generateSSTFromWU C:\temp\certs\RootStore.sst

Write-Host "Importing certificates from Windows Update to the trust store"
$file=Get-ChildItem -Path C:\temp\certs\Rootstore.sst
$file | Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root\

Write-Host "Deleting temporary certificates"
rm -Recurse -Force C:\temp

Write-Host "Continuing in 5 seconds"
Start-Sleep 5
