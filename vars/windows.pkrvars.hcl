disk_size = "25G"
boot_wait = "12m"
communicator = "winrm"
memory = 4096
floppy_files = [
  "./scripts/Autounattend.xml",
  "./scripts/winrm.ps1",
]
iso_path_external = "/home/paul.fournillon/work/qrepos/bringyourownvm"
iso_file = "windows_iso.iso"
iso_checksum = "6dae072e7f78f4ccab74a45341de0d6e2d45c39be25f1f5920a2ab4f51d7bcbb"
disk_interface = "virtio"
# qemuargs = [
#   ["-drive", "file=${path.root}/virtio-win-0.1.217,media=cdrom,index=3"],
#   ["-drive", "file=build/gotham_uses_windows,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"],
#   ["-drive", "file=${var.iso_url},media=cdrom"]
# ]
qemuargs = [
  ["-drive", "file=/home/paul.fournillon/work/qrepos/bringyourownvm/virtio-win-0.1.217.iso,media=cdrom,index=3"],
  ["-drive", "file=build/Qvm,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"],
  ["-drive", "file=/home/paul.fournillon/work/qrepos/bringyourownvm/windows_iso.iso,media=cdrom"],
]
scripts = [
  "./scripts/enable-rdp.bat"
]
