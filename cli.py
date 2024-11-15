#!/usr/bin/python3

import argparse
import docker
import json
import pathlib

parser = argparse.ArgumentParser(
    prog='python3 cli.py',
    description=
    'Create your own virtual machines compatible with Qarnot\'s HPC services.')


def get_next(options: list[dict], id: int) -> dict:
    for option in options:
        if option['id'] == id:
            return option
    return None


def get_answer_type(type: str) -> type:
    match type:
        case "string":
            return str
        case "int":
            return int
        case "list":
            return list
        case _:
            print("Error: An error occured.")
            exit(1)

    return None


def validate_user_answer(answer: any, correct_answers: list[str],
                         type_function: type) -> int:
    if len(correct_answers) == 0:
        return 0
    for i in range(len(correct_answers)):
        if type_function(correct_answers[i]) == answer:
            return i
    return -1


def get_branching(branchings: list[int], answer_index: int) -> int:
    if len(branchings) == 1:
        return branchings[0]

    assert (len(branchings) >= answer_index)
    assert (len(branchings) != 0)

    return branchings[answer_index]


def json_format(input: str | int | list) -> str | int | list:
    if type(input) == str:
        return f"\"{input}\""
    elif type(input) == list:
        return json.dumps(input)
    else:
        return input


def create_build_dir(path: pathlib.Path) -> None:
    try:
        path.mkdir()
    except FileExistsError:
        print(f"The path: {path} already exists.")

    return None


def copy_file(path_src: pathlib.Path, path_dst: pathlib.Path) -> None:
    import shutil
    import filecmp

    try:
        if not path_src.exists() or not path_src.is_file():
            print(f"Source path: {path_src} does not exist or is not a file.")

        if not path_dst.is_file():
            tmp = pathlib.Path(path_dst).joinpath(path_src.name)
            if not tmp.is_file() or (tmp.is_file()
                                     and not filecmp.cmp(tmp, path_src)):
                print(f"Please wait, the file is being copied to {path_dst}.")
                shutil.copy2(path_src, path_dst)
                print("The file was successfully copied.")
            else:
                print("The file already exists.")
    except Exception:
        print("Error: An error occured while copying the file.")
        exit(1)

    return None


def create_var_file(user_config: dict, output_path: str) -> None:
    var_file_path = "./output/vars.json"
    path = None

    user_config.update({"headless": "true"})

    if "iso_path" in user_config:
        path = pathlib.Path(user_config['iso_path'])
        user_config.update({
            "iso_path_external": "/output/",
            "iso_file": path.name
        })

    if user_config['os_guest'].lower() == "windows":
        qemuargs = [
            [
                "-drive",
                f"file={output_path}/qvm.qcow2,if=none,format=qcow2,id=drive-disk0"
            ],
            [
                "-device",
                "virtio-blk-pci,scsi=off,drive=drive-disk0,id=virtio-disk0,bootindex=0"
            ],
            [
                "-drive",
                f"file={user_config['iso_path_external']}/{user_config['iso_file']},media=cdrom,index=1"
            ],
            ["-drive", "file=./virtio-win-0.1.217.iso,media=cdrom,index=2"],
            [
                "-drive",
                f"file={user_config['iso_path_external']}/install-scripts.iso,media=cdrom,index=3"
            ],
        ]
        user_config.update({"qemuargs": qemuargs})
        user_config.update({"disk_interface": "virtio"})
        user_config.update(
            {"http_dir": "./scripts/install-resources/install-scripts/"})
        user_config.update({"communicator": "winrm"})
        user_config.update({"disk_size": "35G"})
        user_config.update({"boot_wait": "10m"})
        user_config.update({"memory": 4096})
        user_config.update({"autounattend_path": "./scripts/Autounattend.xml"})
        user_config.update({
            "init_script_path":
            "./scripts/install-resources/install-scripts/init"
        })
        user_config.update({
            "install_scripts_path":
            "./scripts/install-resources/install-scripts"
        })

    with open(var_file_path, "w", encoding="utf-8") as f:
        json.dump(user_config, f)

    assert (f.closed)
    return None


def export_env_vars(user_config: dict, exportable_vars: list[str]) -> dict:
    env_vars = {}
    for key in user_config:
        if key.upper() in exportable_vars:
            env_vars.update({key.upper(): user_config[key]})

    return env_vars


def dict_add(d: dict, key: str, value: str | int) -> None:
    d.update(json.loads(f"{{\"{key}\": {json_format(value)}}}"))
    return None


# Subfunction to handle the split of iso_path
def update_user_config(current_item: dict, user_input: any,
                       user_config: dict) -> None:
    if current_item['slug'] != '':
        dict_add(user_config, current_item['slug'], user_input)
    return None


def get_user_input(current_item: dict,
                   type_function: int | str | list) -> int | str | list:
    user_input = None
    if type_function == list:
        print(current_item['question'])
        print("Enter 'q' to to continue.")
        tmp = input()
        user_input = []
        while tmp != "q":
            user_input.append(tmp)
            tmp = input()
    else:
        user_input = type_function(input(current_item['question'] + "\n"))

    return user_input


def main(args: any) -> int:
    json_data = None
    exportable_vars = [
        "AUTOUNATTEND_PATH", "INIT_SCRIPT_PATH", "INSTALL_SCRIPTS_PATH",
        "OS_GUEST", "DISK_IMAGE"
    ]
    user_config = {}

    with open('./options.json', encoding="utf-8") as f:
        json_data = json.load(f)

    assert (f.closed)
    assert (json_data != None)

    try:
        next_id = 0

        while next_id != -1:
            next = get_next(json_data['options'], next_id)
            type_function = get_answer_type(next['answer_type'])

            user_input = get_user_input(next, type_function)
            answer_index = validate_user_answer(user_input, next['answers'],
                                                type_function)

            while answer_index == -1:
                print("Incorrect answer. The expected answers are:")
                for answer in next['answers']:
                    print(answer, end=' ')
                print()
                user_input = get_user_input(next, type_function)
                answer_index = validate_user_answer(user_input,
                                                    next['answers'],
                                                    type_function)

            update_user_config(next, user_input, user_config)

            next_id = get_branching(next['branchings'], answer_index)
    except:
        print("Error: JSON (probably) misformed")
        exit(1)

    out_path = pathlib.Path("./output/")
    repo = "docker-qlab.qarnot.net/byovm"
    tag = "test"
    command = "sh -c 'while :; do sleep 100; done'"
    devices_list = ["/dev/kvm", "/dev/kvm"]
    volumes_dict = [f"{str(out_path.absolute())}:/output"]

    create_build_dir(out_path)

    if user_config["iso_path"] == "":
        if user_config["disk_image"] == "true":
            print("Error: An error occured.")
            exit(1)
        user_config.pop("iso_path")
        user_config.pop("iso_checksum")
    else:
        copy_file(pathlib.Path(user_config["iso_path"]), out_path.absolute())
    create_var_file(user_config, str(out_path.absolute()))
    print(user_config)
    env_dict = export_env_vars(user_config, exportable_vars)

    print(env_dict)

    client = docker.from_env()

    print("Pulling the image ...")
    image = client.images.pull(repo, tag=tag)
    print("The Docker image was successfully pulled.")

    print("Running the Docker container ...")
    logs = client.containers.run(f"{repo}:{tag}",
                                 command=command,
                                 privileged=True,
                                 remove=True,
                                 environment=env_dict,
                                 devices=devices_list,
                                 volumes=volumes_dict)

    print(logs)

    return 0


if __name__ == "__main__":
    args = parser.parse_args()
    main(args)
