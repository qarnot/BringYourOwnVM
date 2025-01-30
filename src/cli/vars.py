#!/usr/bin/python3

################################# CLI #########################################

program_command = "python3 cli.py"
program_desc = "Create your own virtual machines compatible with Qarnot\
\'s HPC services."

###################### Internal Config Variables ##############################

_repo = "docker-qlab.qarnot.net/byovm"
_tag = "test_release"
_out_path = "./output"
_in_path = "/output"
_command = "sh -c 'while :; do sleep 100; done'"
_devices_list = ["/dev/kvm", "/dev/kvm"]

_exportable_vars = ["OS_GUEST", "DISK_IMAGE", "PACKER_LOG", "CLOUD_IMAGE"]

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
scripts = "scripts"
disk_image = "disk_image"
headless = "headless"
http_dir = "http_dir"
scripts_dir = "scripts_dir"
root_password = "root_password"
playbooks_dir = "playbooks_dir"
files_dir = "files_dir"
preseed_path = "preseed_path"
preseed_file = "preseed_file"
cloud_init_path = "cloud_init_path"
playbooks = "playbook_files"
distro = "distro"
vm_name = "vm_name"
cloud_image = "cloud_image"

confirm = "confirm"
root_enable = "root_enable"

###############################################################################

default_script_linux = "./provisions/scripts/linux/linux_init.sh"
default_script_cloud_init = "./provisions/scripts/linux/cloud_init.sh"
default_script_ansible = "./provisions/scripts/linux/ansible.sh"
upgrade_playbook = "./provisions/playbooks/playbook-upgrade.yml"
qarnot_playbook = "./provisions/playbooks/playbook-qarnot.yml"
