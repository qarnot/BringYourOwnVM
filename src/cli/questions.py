#!/usr/bin/python3

from InquirerPy.validator import NumberValidator, EmptyInputValidator, PathValidator

questions = [
    {
        "name": "disk_image",
        "message": "Do you already have a base virtual machine image to provide ?\n('No' if you have an ISO file)",
        "type": "rawlist",
        "mandatory": True,
        "choices": ["Yes", "No"],
        "filter": lambda result: "true" if result == "Yes" else "false",
    },
    {
        "name": "os_guest",
        "message": lambda result:  "Which Operating System does your VM use ?" if result["disk_image"] == "true" else "Which Operating System do you want ?",
        "type": "rawlist",
        "mandatory": True,
        "choices": lambda result: ["Windows", "GNU/Linux"]
        if result["disk_image"] == "false"
        else ["GNU/Linux"],
        "filter": lambda result: "windows" if result == "Windows" else "linux",
    },
    {
        "name": "distro",
        "message": lambda result:  "Which Linux distribution do you want to use ?",
        "type": "rawlist",
        "mandatory": True,
        "choices": lambda result: ["Debian", "Ubuntu Server", "Ubuntu Desktop"],
        "filter": lambda result: "debian" if result == "Debian" else "ubuntu_server" if result == "Ubuntu Server" else "ubuntu_desktop",
        "when": lambda result: result["os_guest"] == "linux"
    },
    # {
    #     "name": "disk_size",
    #     "message": "Which size the disk should be for the VM to work ?\n(At least 10G for Debian/Ubuntu and 30G for Windows)",
    #     "type": "input",
    #     "mandatory": True,
    #     "filter": lambda result: f"{result}G",
    #     "validate": NumberValidator(),
    #     # "when": lambda result: result["os_guest"] == "linux"
    # },
    # {
    #     "name": "vm_name",
    #     "message": "What name for the VM ?",
    #     "type": "input",
    #     # "mandatory": True,
    #     # "when": lambda result: result["os_guest"] == "linux"
    # },
    {
        "name": "root_enable",
        "message": "Do you want to enable the root user ?",
        "type": "confirm",
        "default": True,
        "mandatory": True,
        "when": lambda result: result["disk_image"] == "false" and result["os_guest"] == "linux" and result["distro"] == "debian",
    },
    {
        "name": "root_password",
        "message": "Please, provide a password for the root user:",
        "type": "password",
        "mandatory": True,
        "validate": EmptyInputValidator(),
        "transformer": lambda _: "[hidden]",
        "when": lambda result: result["root_enable"],
    },
    {
        "name": "ssh_username",
        "message": lambda result: "Provide a username for SSH connections:\n(This user must already exist on your VM, SSH connection using this user must be allowed.)" if result["disk_image"] == "true" and result["os_guest"] == "linux" else "Provide a username for the user to be created\n(it must match a user defined in your configuration file):",
        "type": "input",
        "mandatory": True,
        "validate": EmptyInputValidator(),
    },
    {
        "name": "ssh_password",
        "message": lambda result: "Provide the password of this user for SSH connections:" if result["disk_image"] == "true" and result["os_guest"] == "linux" else "Provide a password for this user:",
        "type": "password",
        "transformer": lambda _: "[hidden]",
    },
    {
        "name": "iso_path",
        "message": lambda result: "Please, specify the path to your VM (qcow2 format required):" if result["disk_image"] == "true" else "Please, specify the path to your ISO:",
        "type": "filepath",
        "validate": PathValidator(is_file=True, message="Input is not a file") and EmptyInputValidator(),
        "mandatory": True,
    },
    {
        "name": "iso_checksum",
        "message": "Please, specify the checksum:",
        "type": "input",
    },
    {
        "name": "preseed_path",
        "message": "Specify the path to a preseed file:",
        "type": "filepath",
        "validate": PathValidator(is_file=True, message="Input is not a file") and EmptyInputValidator(),
        "mandatory": True,
        "when": lambda result: result["disk_image"] == "false" and result["distro"] == "debian"
    },
    {
        "name": "cloud_init_path",
        "message": "Provide the path to a directory containing cloud-init\nconfiguration files (user-data, meta-data):",
        "type": "filepath",
        "validate": PathValidator(is_dir=True, message="Input is not a directory") and EmptyInputValidator(),
        "mandatory": True,
        "when": lambda result: result["disk_image"] == "false" and result["distro"] != "debian" and result["os_guest"] == "linux"
    },
    {
        "name": "scripts_dir",
        "message": "Provide the path to a directory containing additional configuration scripts:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True, message="Input is not a directory"),
    },
    {
        "name": "playbooks_dir",
        "message": "Provide the path to a directory containing additional Ansible playbooks:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True, message="Input is not a directory"),
        "when": lambda result: result["os_guest"] == "linux"
    },
    {
        "name": "files_dir",
        "message": "Provide the path to a directory containing additional files to copy inside the VM:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True, message="Input is not a directory"),
        "when": lambda result: result["disk_image"] == "false" and result["os_guest"] == "linux"
    },
    {
        "name": "confirm",
        "message": "Do you confirm your configuration ?",
        "type": "confirm",
        "default": True,
    },
]
