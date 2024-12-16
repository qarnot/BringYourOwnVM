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

echo "Setup powercfg after sleeping 5"
Start-Sleep -Seconds 5

# Disable hibernate
powercfg.exe /h off

# Set the power profile to "high performance". Use "powercfg /list" in a running
# instance to see available profiles and their associated Guids
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Disable hybrid sleep in the high performance power profile
powercfg /setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e  000
powercfg /setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e  000
