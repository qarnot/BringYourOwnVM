### This script is and SHOULD REMAIN the absolute minimal that is included in the Windows OS
# image. What it does is simply copy the content of an additional ISO drive (D:) to C:, and
# then pass the relay to C:\Qarnot\bootstrap-stage-2.ps1. Hence, the additional ISO drive must
# include a file at D:\Qarnot\init\bootstrap-stage-2.ps1.
# This way of doing things allows us to customize the Windows at boot time instead of build
# time, easing development and upgrades.

$LOG_FILE="C:\Qarnot\logs\bootstrap.log"

Function Log {
    param(
        [Parameter(Mandatory=$true)][String]$msg
    )

    $date = date
    Add-Content $LOG_FILE "${date}: $msg"
    Send-SyslogMessage -Server syslog.task.qarnot.loc -Transport 'TCP' -Facility user -Severity Warning -Message $msg
}


# We wait for an IP address here so that we have a chance that our syslog calls will succeed
echo "Wait for an IP address"
$retry = 0
while (ipconfig | find """169.254""") {
    Log "Don't have ip address, retry in 5 sec ($retry/30)"
    sleep 5
    $retry++
    if ($retry -gt 60) {
        Log "Fail to have ip address"
        exit 1
    }
}

echo "Create Qarnot\logs directory"
mkdir C:\Qarnot\logs

Log "Drives available on the machine:"
Get-PSDrive >>$LOG_FILE 2>&1

while (!(Test-Path D:)) {
    Log "Waiting for D: to be available"
    Start-Sleep 1
}

Log "D: is available, proceed with copy"

# NOTE: the /COPY:DT is there to tell robocopy not to copy the metadata. For some reason,
# the startup service does not have privileges to manipulate metadata, and it ends up with
# the following error:
#   ERROR 5 (0x00000005) Changing File Attributes: Access is denied
# Thanks https://ignitedsoul.com/2012/07/12/robocopy-error-5-0x00000005-changing-file-attributes-access-is-denied/ for the solution

Log "Copying content of D: to C: using recursive robocopy"
robocopy D:\ C:\ /s /COPY:DT >>$LOG_FILE 2>&1

Log "Content of C:\Qarnot:"
ls C:\Qarnot >>$LOG_FILE 2>&1



$stage2 = "C:\Qarnot\init\bootstrap-stage-2.ps1"
echo "Now passing control to stage 2: $stage2"
powershell $stage2
