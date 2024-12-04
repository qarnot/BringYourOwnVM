#!/usr/bin/python3

from InquirerPy.validator import NumberValidator, EmptyInputValidator, PathValidator

questions = [
    {
        "name": "disk_image",
        "message": "Do you already have a base VM image to provide ?",
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
        "choices": ["Windows", "GNU/Linux"],
        "filter": lambda result: "windows" if result == "Windows" else "linux",
        # "when": lambda result: result["disk_image"] == "true",
    },
    # {
    #     "name": "os_guest",
    #     "message": "Which Operating System do you want ?",
    #     "type": "rawlist",
    #     "mandatory": True,
    #     "choices": ["Windows", "GNU/Linux"],
    #     "filter": lambda result: "windows" if result == "Windows" else "linux",
    #     "when": lambda result: result["disk_image"] == "false",
    # },
    {
        "name": "root_enable",
        "message": "Do you want to enable the root user ?",
        "type": "confirm",
        "default": True,
        "mandatory": True,
        "when": lambda result: result["disk_image"] == "false" and result["os_guest"] == "linux",
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
        "message": lambda result: "Provide a username for SSH connections:\n(This user must already exist on your VM, SSH connection using this user must be allowed.)" if result["disk_image"] == "true" and result["os_guest"] == "linux" else "Provide a username for the user to be created:",
        "type": "input",
        "mandatory": True,
        "validate": EmptyInputValidator(),
        # "when": lambda result: result["disk_image"] == "true" and result["os_guest"] == "linux",
    },
    {
        "name": "ssh_password",
        "message": lambda result: "Provide the password of this user for SSH connections:" if result["disk_image"] == "true" and result["os_guest"] == "linux" else "Provide a password for this user:",
        "type": "password",
        "transformer": lambda _: "[hidden]",
        # "when": lambda result: result["disk_image"] == "true" and result["os_guest"] == "linux",
    },
    # {
    #     "name": "ssh_username",
    #     "message": "Provide a username for the user to be created:",
    #     "type": "input",
    #     "mandatory": True,
    #     "validate": EmptyInputValidator(),
    #     "when": lambda result: result["disk_image"] == "false" and result["os_guest"] == "linux",
    #     # "when": lambda result: not result["root_enable"]
    # },
    # {
    #     "name": "ssh_username",
    #     "message": "Provide a username for the user to be created:",
    #     "type": "input",
    #     "when": lambda result: result["root_enable"]
    # },
    # {
    #     "name": "ssh_password",
    #     "message": "Provide a password for this user:",
    #     "type": "password",
    #     "transformer": lambda _: "[hidden]",
    #     "when": lambda result: result["disk_image"] == "false" and result["os_guest"] == "linux",
    # },
    {
        "name": "iso_path",
        "message": lambda result: "Please, specify the path to your VM (qcow2 format required):" if result["disk_image"] == "true" else "Please, specify the path to your ISO:",
        "type": "filepath",
        "validate": PathValidator(is_file=True, message="Input is not a file"),
        "mandatory": True,
        # "when": lambda result: result["disk_image"] == "true",
    },
    # {
    #     "name": "iso_path",
    #     "message": "Please, specify the path (absolute) to your ISO:",
    #     "type": "filepath",
    #     "validate": lambda result: PathValidator(is_file=True, message="Input is not a file") or result == "",
    #     # "mandatory": True,
    #     "when": lambda result: result["disk_image"] == "false",
    # },
    {
        "name": "iso_checksum",
        "message": "Please, specify the checksum:",
        "type": "input",
        # "filter": lambda result:
    },
    {
        "name": "scripts_dir",
        "message": "Provide the path to a directory containing additional configuration scripts:",
        "type": "filepath",
        "validate": PathValidator(is_dir=True, message="Input is not a directory"),
    },
    {
        "name": "confirm",
        "message": "Do you confirm your configuration ?",
        "type": "confirm",
        "default": True,
    },
]
