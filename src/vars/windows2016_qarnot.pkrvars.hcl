disk_size = "35G"
boot_wait = "10m"
communicator = "winrm"
memory = 4096
headless = true

autounattend_path = "./scripts/Autounattend.xml"
init_script_path = "./scripts/install-resources/install-scripts/init"
install_scripts_path = "./scripts/install-resources/install-scripts"

# floppy_files = [
#   "./scripts/Autounattend.xml",
# ]

# floppy_dirs = [
#   "./scripts/install-resources/install-scripts/*"
# ]

iso_path_external = "iso/"
iso_file = "windows_2016.iso"
iso_checksum = "47919ce8b4993f531ca1fa3f85941f4a72b47ebaa4d3a321fecf83ca9d17e6b8"
disk_interface = "virtio"
http_dir = "./scripts/install-resources/install-scripts/"

qemuargs = [
  [ "-drive", "file=build/qvm.qcow2,if=none,format=qcow2,id=drive-disk0" ],
  [ "-device", "virtio-blk-pci,scsi=off,drive=drive-disk0,id=virtio-disk0,bootindex=0" ],
  [ "-drive", "file=iso/windows_2016.iso,media=cdrom,index=1" ],
  [ "-drive", "file=iso/virtio-win-0.1.217.iso,media=cdrom,index=2" ],
  [ "-drive", "file=iso/install-scripts.iso,media=cdrom,index=3" ],
]

scripts = [
  "./scripts/enable-rdp.bat"
]
