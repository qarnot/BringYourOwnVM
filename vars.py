#!/usr/bin/python3

################################# CLI #########################################

program_command = "python3 cli.py"
program_desc = "Create your own virtual machines compatible with Qarnot\
\'s HPC services."

###################### Internal Config Variables ##############################

_repo = "docker-qlab.qarnot.net/byovm"
_tag = "test"
_out_path = "./output"
_in_path = "/output"
_command = "sh -c 'while :; do sleep 100; done'"
_devices_list = ["/dev/kvm", "/dev/kvm"]

_exportable_vars = [
    "AUTOUNATTEND_PATH", "INIT_SCRIPT_PATH", "INSTALL_SCRIPTS_PATH",
    "OS_GUEST", "DISK_IMAGE", "PACKER_LOG"
]

## Vars file config Packer
_var_file_name = "vars.json"

###############################################################################

## Questions InquirerPy
name = "name"
message = "message"
type = "type"
mandatory = "mandatory"
choices = "choices"
filter = "filter"
transformer = "transformer"
when = "when"
validate = "validate"

## Names of Packer variables: must correspond to variables defined in templates
iso_path = "iso_path"
iso_path_external = "iso_path_external"
iso_file = "iso_file"
iso_checksum = "iso_checksum"
os_guest = "os_guest"
qemuargs = "qemuargs"
communicator = "communicator"
disk_size = "disk_size"
disk_interface = "disk_interface"
boot_wait = "boot_wait"
memory = "memory"
autounattend_path = "autounattend_path"
install_scripts_path = "install_scripts_path"
init_script_path = "init_script_path"
scripts = "scripts"
disk_image = "disk_image"
headless = "headless"
http_dir = "http_dir"
scripts_dir = "scripts_dir"
root_password = "root_password"


confirm = "confirm"
root_enable = "root_enable"

###############################################################################

qemuargs_list = [
            [
                "-drive",
                f"file=build/qvm.qcow2,if=none,format=qcow2,id=drive-disk0"
            ],
            [
                "-device",
                "virtio-blk-pci,scsi=off,drive=drive-disk0,id=virtio-disk0,bootindex=0"
            ],
            [
                "-drive",
            ],
            ["-drive", "file=./virtio-win-0.1.217.iso,media=cdrom,index=2"],
            [
                "-drive",
            ],
        ]

windows_specific = {
    disk_interface: "virtio",
    http_dir: "./scripts/install-resources/install-scripts/",
    communicator: "winrm",
    disk_size: "35G",
    boot_wait: "10m",
    memory: 4096,
    autounattend_path: "./scripts/Autounattend.xml",
    init_script_path: "./scripts/install-resources/init/bootstrap.ps1",
    install_scripts_path: "./scripts/install-resources/install-scripts",
    # scripts: ["./scripts/install-resources/install-scripts/enable-rdp.bat"]
}

default_script_linux = "./scripts/linux/script1.sh"
default_script_win = "./scripts/win/script1.bat"
