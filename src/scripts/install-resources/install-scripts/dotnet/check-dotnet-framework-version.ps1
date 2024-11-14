# The progress window takes part of the screen, let's try to overflow it, and
# make it slow enough that we can search for it in the install video.
# This is a completely clumsy, but at least handy..

for ($i=0; $i -lt 30; $i++)
{
    echo "dotnet framework version"
    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"

    Start-Sleep -Seconds 1
}
