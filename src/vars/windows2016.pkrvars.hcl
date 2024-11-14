disk_size = "35G"
boot_wait = "10m"
communicator = "winrm"
memory = 4096
floppy_files = [
  "./scripts/Autounattend.xml",
  "./scripts/winrm.ps1",
]
iso_path_external = "/home/paul.fournillon/work/qrepos/bringyourownvm/iso"
iso_file = "windows_2016.iso"
iso_checksum = "1ce702a578a3cb1ac3d14873980838590f06d5b7101c5daaccbac9d73f1fb50f"
disk_interface = "virtio"

qemuargs = [
  [ "-drive", "file=iso/virtio-win-0.1.217.iso,media=cdrom,index=3" ],
  [ "-drive", "file=build/qvm.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1" ],
  [ "-drive", "file=iso/windows_2016.iso,media=cdrom" ],
]
scripts = [
  "./scripts/enable-rdp.bat"
]
