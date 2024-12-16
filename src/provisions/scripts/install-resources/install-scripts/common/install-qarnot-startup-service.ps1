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


echo "Copy bootstrap script and set it up as nssm startup service"

# Just so that it can be followed visually step by step
Start-Sleep -Seconds 5

# Equivalent of a set -e in a posix shell
$ErrorActionPreference="Stop"

mkdir C:\Qarnot\init
mkdir C:\Qarnot\logs
copy F:\bootstrap.ps1 C:\Qarnot\init\bootstrap.ps1

nssm install qarnot-init "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-file C:\Qarnot\init\bootstrap.ps1"
nssm set qarnot-init AppStdout C:\Qarnot\logs\qarnot-init-nssm-out.log
nssm set qarnot-init AppStderr C:\Qarnot\logs\qarnot-init-nssm-err.log
nssm set qarnot-init AppExit Default Ignore

echo "Install completed, sleep 5 and continue"
Start-Sleep -Seconds 5
