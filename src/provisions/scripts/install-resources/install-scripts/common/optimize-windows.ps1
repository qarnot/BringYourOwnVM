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

# Clean and optimize Windows image

echo "Clean Windows"
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase /Quiet
Dism.exe /online /Cleanup-Image /SPSuperseded /Quiet

echo "Remove downloads"
Remove-Item "C:\Windows\SoftwareDistribution\Download\" -Recurse -Force
Remove-Item "C:\Windows\SoftwareDistribution\DataStore\" -Recurse -Force

Write-host "Defragment disk C:"
Optimize-Volume -DriveLetter C -Analyze -NormalPriority -Verbose -Defrag

Write-host "zero fill disk and delete"
sdelete /accepteula -z C:
