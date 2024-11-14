disk_size = "35G"
boot_wait = "10m"
communicator = "winrm"
memory = 4096
floppy_files = [
  "./scripts/Autounattend.xml",
  "./scripts/winrm.ps1",
]
iso_path_external = "/home/paul.fournillon/work/qrepos/bringyourownvm/iso"
iso_file = "windows_2022.iso"
iso_checksum = "3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
disk_interface = "virtio"

qemuargs = [
  [ "-drive", "file=iso/virtio-win-0.1.217.iso,media=cdrom,index=3" ],
  [ "-drive", "file=build/qvm.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1" ],
  [ "-drive", "file=iso/windows_2022.iso,media=cdrom" ],
]
scripts = [
  "./scripts/enable-rdp.bat"
]
