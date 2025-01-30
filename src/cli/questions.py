#!/usr/bin/python3

from InquirerPy.validator import NumberValidator, EmptyInputValidator, PathValidator

questions = [
    {
        "name": "disk_image",
        "message":
        "Do you already have a base virtual machine image to provide ?\n('No' if you have an ISO file or a cloud image)",
        "type": "rawlist",
        "mandatory": True,
        "choices": ["Yes", "No"],
        "filter": lambda result: "true" if result == "Yes" else "false",
    },
    {
        "name": "cloud_image",
        "message": "Do you have a cloud-image ?\n('No' if you have an ISO file)",
        "type": "rawlist",
        "mandatory": True,
        "choices": ["Yes", "No"],
        "filter": lambda result: "true" if result == "Yes" else "false",
        "when": lambda result: result["disk_image"] == "false",
    },
    {
        "name":
        "distro",
        "message":
        "Which Linux distribution do you want to use ?",
        "type":
        "rawlist",
        "mandatory":
        True,
        "choices":
        lambda result: ["Debian", "Ubuntu Server", "Ubuntu Desktop"],
        "filter":
        lambda result: "debian" if result == "Debian" else "ubuntu_server"
        if result == "Ubuntu Server" else "ubuntu_desktop",
        "when": lambda result: result["cloud_image"] == "false"
    },
    {
        "name": "vm_name",
        "message": "What name for the VM ?",
        "type": "input",
        "mandatory": True,
        "validate": EmptyInputValidator(),
    },
    {
        "name":
        "disk_size",
        "message":
        "Which size the disk should be for the VM to work ? \n(At least 10G for Debian/Ubuntu)",
        "type":
        "number",
        "mandatory":
        True,
        "filter":
        lambda result: int(result),
        "default":
        10,
        # "min_allowed": 10,
        "max_allowed":
        1000,
        "validate":
        lambda result: EmptyInputValidator() and NumberValidator() and int(
            result) >= 10,
    },
    {
        "name":
        "root_enable",
        "message":
        "Do you want to enable the root user ?",
        "type":
        "confirm",
        "default":
        True,
        "mandatory":
        True,
        "when":
        lambda result: result["disk_image"] == "false" and result["distro"] ==
        "debian",
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
        "name":
        "ssh_username",
        "message":
        lambda result:
        "Provide a username for SSH connections:\n(This user must already exist on your VM, SSH connection using this user must be allowed.)"
        if result["disk_image"] == "true" else
        "Provide a username for the user to be created\n(it must match a user defined in your configuration file):",
        "type":
        "input",
        "mandatory":
        True,
        "validate":
        EmptyInputValidator(),
        "when": lambda result: result["cloud_image"] == "false"
    },
    {
        "name":
        "ssh_password",
        "message":
        lambda result: "Provide the password of this user for SSH connections:"
        if result["disk_image"] == "true" else
        "Provide a password for this user:",
        "type":
        "password",
        "transformer":
        lambda _: "[hidden]",
        "when": lambda result: result["cloud_image"] == "false"
    },
    {
        "name":
        "iso_path",
        "message":
        lambda result:
        "Please, specify the path to your image (qcow2 format required):"
        if result["disk_image"
                  ] == "true" or result["cloud_image"] == "true" else "Please, specify the path to your ISO:",
        "type":
        "filepath",
        "validate":
        PathValidator(is_file=True, message="Input is not a file")
        and EmptyInputValidator(),
        "mandatory":
        True,
    },
    {
        "name": "iso_checksum",
        "message": "Please, specify the checksum:",
        "type": "input",
    },
    {
        "name":
        "preseed_path",
        "message":
        "Specify the path to a preseed file:",
        "type":
        "filepath",
        "validate":
        PathValidator(is_file=True, message="Input is not a file")
        and EmptyInputValidator(),
        "mandatory":
        True,
        "when":
        lambda result: result["disk_image"] == "false" and result[
            "distro"] == "debian",
    },
    {
        "name":
        "cloud_init_path",
        "message":
        "Provide the path to a directory containing cloud-init\nconfiguration files (user-data, meta-data):",
        "type":
        "filepath",
        "validate":
        PathValidator(is_dir=True, message="Input is not a directory")
        and EmptyInputValidator(),
        "mandatory":
        True,
        "when":
        lambda result: result["disk_image"] == "false" and result[
            "distro"] != "debian" and result["cloud_image"] == "false",
    },
    {
        "name": "scripts_dir",
        "message":
        "Provide the path to a directory containing additional configuration scripts:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True,
                                  message="Input is not a directory"),
    },
    {
        "name": "playbooks_dir",
        "message":
        "Provide the path to a directory containing additional Ansible playbooks:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True,
                                  message="Input is not a directory"),
    },
    {
        "name": "files_dir",
        "message":
        "Provide the path to a directory containing additional files to copy inside the VM:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True,
                                  message="Input is not a directory"),
        "when": lambda result: result["disk_image"] == "false",
    },
    {
        "name": "confirm",
        "message": "Do you confirm your configuration ?",
        "type": "confirm",
        "default": True,
    },
]
