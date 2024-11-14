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

echo "Forcing TLS 1.2 in ServicePointManager and install PowerShellGet"

#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Install-Module PowerShellGet -RequiredVersion 2.2.4 -SkipPublisherCheck

# https://dev.to/darksmile92/powershell-disabled-support-for-tls-1-0-for-the-gallery-update-module-and-install-module-broken-1oii

echo "Forcing to TLS 1.2"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

echo "Install nuget as a package provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Import-PackageProvider NuGet -Force

echo "Listing PS repositories"
Get-PSRepository

echo "Set PSGallery as trusted"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
