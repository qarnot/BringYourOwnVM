disk_size = "35G"
boot_wait = "10m"
communicator = "winrm"
memory = 4096
floppy_files = [
  "./scripts/Autounattend.xml",
  "./scripts/winrm.ps1",
]
iso_path_external = "/home/paul.fournillon/work/qrepos/bringyourownvm/iso"
iso_file = "windows_2019.iso"
iso_checksum = "6dae072e7f78f4ccab74a45341de0d6e2d45c39be25f1f5920a2ab4f51d7bcbb"
disk_interface = "virtio"

qemuargs = [
  [ "-drive", "file=iso/virtio-win-0.1.217.iso,media=cdrom,index=3" ],
  [ "-drive", "file=build/qvm.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1" ],
  [ "-drive", "file=iso/windows_2019.iso,media=cdrom" ],
]
scripts = [
  "./scripts/enable-rdp.bat"
]
