#!/usr/bin/python3

import argparse
from sys import exit

from questions import questions
from utils import *
import config

parser = argparse.ArgumentParser(prog=vars.program_command,
                                 description=vars.program_desc)

parser.add_argument('-v', '--verbose', help='enable the verbose mode', action='store_true')


def create_var_file(conf: config.Config, user_config: dict,
                    output_path: str) -> None:

    with open(conf.var_file_path, "w", encoding="utf-8") as f:
        json.dump(user_config, f)

    assert (f.closed)
    return None


def export_env_vars(user_config: dict, exportable_vars: list[str], verbose: bool) -> dict:
    env_vars = {}

    for key in user_config:
        if key.upper() in exportable_vars:
            env_vars.update({key.upper(): user_config[key]})

    env_vars.update({"PACKER_LOG": 1 if verbose else 0})

    return env_vars


def get_user_config(questions: list[dict]) -> dict:
    import InquirerPy

    user_config = InquirerPy.prompt(questions=questions)

    if not user_config[vars.confirm]:
        exit(1)

    return user_config


def get_qemuargs(conf: config.Config, user_config: dict) -> list:
    res = vars.qemuargs_list

    res[2].append(f"file={user_config[vars.iso_path_external]}/{user_config[vars.iso_file]},media=cdrom,index=1")
    res[4].append(f"file={conf.in_path}/install-scripts.iso,media=cdrom,index=3")

    return res


def configure_iso_path(user_config: dict) -> bool:
    copy = True

    if user_config[vars.iso_path] == "":
        copy = False
        if user_config[vars.disk_image] == "true":
            print("Error: An error occured.")
            exit(1)
        user_config.pop(vars.iso_path)
        user_config.pop(vars.iso_checksum)

    return copy


def enumerate_files(path: str, os: str) -> list[str]:
    dir_path = pathlib.Path(path)
    res = [vars.default_script_linux if os == "linux" else vars.default_script_win]

    for item in dir_path.iterdir():
        if item.is_file():
            res.append(item)

    print(res)
    return res


def configure_scripts_dir(user_config: dict, conf: config.Config) -> None:
    from distutils.dir_util import copy_tree

    scripts = []

    if user_config[vars.scripts_dir] == "":
        user_config.pop(vars.scripts_dir)
    else:
        scripts_dir_path = pathlib.Path(user_config[vars.scripts_dir])
        scripts = copy_tree(user_config[vars.scripts_dir], conf.out_path.joinpath(scripts_dir_path.name))
        scripts = ["/" + item for item in scripts]

    scripts.append(vars.default_script_linux if user_config[vars.os_guest] == "linux" else vars.default_script_win)
    user_config.update({vars.scripts: scripts})

    return None


def prune_user_config(user_config: dict, conf: config.Config) -> bool:

    copy = configure_iso_path(user_config)

    configure_scripts_dir(user_config, conf)

    to_pop = [vars.confirm]

    for key in user_config:
        if user_config[key] == None or user_config[key] == "" or key == vars.root_enable:
            to_pop.append(key)

    for key in to_pop:
        user_config.pop(key)

    return copy


def setup_user_config(conf: config.Config, user_config: dict) -> bool:
    path = None

    user_config.update({vars.headless: "true"})

    copy = prune_user_config(user_config, conf)

    if vars.iso_path in user_config:
        path = pathlib.Path(user_config[vars.iso_path])

        if vars.iso_checksum not in user_config:
            user_config[vars.iso_checksum] = get_checksum(
            pathlib.Path(user_config[vars.iso_path]))

        user_config.update({
            vars.iso_path_external: str(conf.in_path.absolute()),
            vars.iso_file: path.name
        })

    if user_config[vars.os_guest].lower() == "windows":
        qemuargs_list = get_qemuargs(conf, user_config)

        user_config.update({vars.qemuargs: qemuargs_list})
        user_config.update(vars.windows_specific)

    return copy


def vm_creation(conf: config.Config, env_dict: dict) -> int:
    import docker

    client = docker.from_env()

    print("Pulling the image ...")
    # image = client.images.pull(conf.repo, tag=conf.tag)
    print("The Docker image was successfully pulled.")

    print("Running the Docker container ...")
    container = client.containers.run(f"{conf.repo}:{conf.tag}",
                                      command=conf.command,
                                      privileged=True,
                                      remove=True,
                                      environment=env_dict,
                                      devices=conf.devices_list,
                                      volumes=conf.volumes_dict,
                                      detach=True)

    for line in container.logs(stream=True):
        print(line.strip().decode("utf-8"))

    return container.wait()["StatusCode"]


def main(args: any) -> int:
    ret = 0

    print(ascii_art("BYOVM"))

    try:
        user_config = get_user_config(questions)

        conf = config.Config()

        create_build_dir(conf.out_path)

        copy = setup_user_config(conf, user_config)

        if copy:
            copy_file(pathlib.Path(user_config[vars.iso_path]),
                      conf.out_path.absolute())

        create_var_file(conf, user_config, str(conf.out_path.absolute()))

        env_dict = export_env_vars(user_config, conf.exportable_vars, args.verbose)

        ret = vm_creation(conf, env_dict)

    except KeyboardInterrupt:
        print("The program is exiting.")
        exit(1)

    return ret


if __name__ == "__main__":
    args = parser.parse_args()
    main(args)
