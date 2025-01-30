#!/usr/bin/python3

from argparse import ArgumentParser
from shutil import copytree
from sys import exit

from src.cli.questions import questions
from src.cli.utils import *
from src.cli import config
from src.cli import vars


def create_var_file(conf: config.Config, user_config: dict,
                    output_path: str) -> None:

    with open(conf.var_file_path, "w", encoding="utf-8") as f:
        json.dump(user_config, f)

    assert (f.closed)
    return None


def load_config_file(file: str) -> dict:
    user_config: dict = {}

    try:
        with open(file, "r", encoding="utf-8") as f:
            user_config: dict = json.load(f)
    except:
        print("Error: An error occured while reading the configuration.")
        exit(1)

    assert(f.closed)
    return user_config


def export_env_vars(user_config: dict, exportable_vars: list[str],
                    verbose: bool) -> dict:
    env_vars: dict = {}

    for key in user_config:
        if key.upper() in exportable_vars:
            env_vars.update({key.upper(): user_config[key]})

    env_vars.update({"PACKER_LOG": 1 if verbose else 0})
    env_vars.update({"OS_GUEST": "linux"})

    return env_vars


def get_user_config(questions: list[dict]) -> dict:
    import InquirerPy

    style = {
        "question": "bold #FFA500",
        "answer": "bold #00FF00",
        "pointer": "bold #FF0000",
        "highlighted": "bold #0000FF bg:#FFFF00",
        "separator": "",
        "instruction": "italic #888888",
        "input": "#00CED1",
        "questionmark": "fg:#FFD700",
    }

    user_config: dict = InquirerPy.prompt(questions=questions, style=style)

    if not user_config[vars.confirm]:
        exit(1)

    return user_config


def configure_iso_path(user_config: dict) -> bool:
    copy: bool = True

    if user_config[vars.iso_path] == "":
        copy: bool = False
        if user_config[vars.disk_image] == "true":
            print("Error: An error occured.")
            exit(1)
        user_config.pop(vars.iso_path)
        user_config.pop(vars.iso_checksum)

    return copy


def enumerate_files(path: str, os: str) -> list:
    dir_path: pathlib.Path = pathlib.Path(path)
    res: list = [
        vars.default_script_linux if os == "linux" else vars.default_script_win
    ]

    for item in dir_path.iterdir():
        if item.is_file():
            res.append(item)

    return res


def configure_scripts_dir(user_config: dict, conf: config.Config) -> None:
    scripts: list = []

    if user_config[vars.scripts_dir] == "" or user_config[
            vars.scripts_dir] == None:
        user_config.pop(vars.scripts_dir)
    else:
        scripts: list = copy_dir(conf, user_config, vars.scripts_dir)

    if len(scripts) != 0:
        user_config.update({vars.scripts: scripts})

    return None


def configure_playbooks_dir(user_config: dict, conf: config.Config) -> None:
    playbooks: list = []

    if user_config[vars.playbooks_dir] == "" or user_config[
            vars.playbooks_dir] == None:
        user_config.pop(vars.playbooks_dir)
    else:
        playbooks: list = copy_dir(conf, user_config, vars.playbooks_dir)

    playbooks.append(vars.upgrade_playbook)
    playbooks.append(vars.qarnot_playbook)
    user_config.update({vars.playbooks: playbooks})

    return None


def prune_user_config(user_config: dict) -> None:
    to_pop: list = [vars.confirm]

    for key in user_config:
        if user_config[key] == None or user_config[
                key] == "" or key == vars.root_enable:
            to_pop.append(key)

    for key in to_pop:
        user_config.pop(key)

    return None


def setup_user_config(conf: config.Config, user_config: dict) -> bool:
    path: pathlib.Path = None
    copy: bool = True

    user_config.update({vars.headless: "true"})

    configure_scripts_dir(user_config, conf)
    configure_playbooks_dir(user_config, conf)

    prune_user_config(user_config)

    copy_dir(conf, user_config, vars.files_dir)
    copy_dir(conf, user_config, vars.cloud_init_path)

    if vars.preseed_path in user_config:
        preseed_path: pathlib.Path = pathlib.Path(
            user_config[vars.preseed_path])
        copy_file(preseed_path, conf.out_path.joinpath(preseed_path.name))
        user_config.update({
            vars.preseed_path:
            "/" + str(conf.out_path.joinpath(preseed_path.name))
        })
        user_config.update({vars.preseed_file: str(preseed_path.name)})

    if vars.iso_path in user_config:
        path: pathlib.Path = pathlib.Path(user_config[vars.iso_path])

        if vars.iso_checksum not in user_config:
            user_config[vars.iso_checksum]: str = get_checksum(path)

        if conf.out_path.joinpath(path.name).exists():
            if user_config[vars.iso_checksum] == get_checksum(
                    conf.out_path.joinpath(path.name)):
                copy = False

        user_config.update({
            vars.iso_path_external: str(conf.in_path.absolute()),
            vars.iso_file: path.name
        })

    return copy


def vm_creation(conf: config.Config, env_dict: dict) -> int:
    import docker

    # try catch to grab errors when DOCKER_HOST is set
    try:
        client: docker.client.DockerClient = docker.from_env()

        print("Pulling the image ...")
        # image: docker.models.images.Image = client.images.pull(conf.repo,
        #                                                        tag=conf.tag)
        print("The Docker image was successfully pulled.")
    except:
        print(
            "An error happened initializing Docker, make sure the DOCKER_HOST variable is set to the correct value."
        )
        exit(1)

    print("Running the Docker container ...")
    try:
        container: docker.models.cotainers.Container = client.containers.run(
            f"{conf.repo}:{conf.tag}",
            command=conf.command,
            privileged=True,
            remove=True,
            environment=env_dict,
            devices=conf.devices_list,
            volumes=conf.volumes_dict,
            detach=True)

        for line in container.logs(stream=True):
            print(line.strip().decode("utf-8"))
    except:
        container.stop()
        raise KeyboardInterrupt

    return container.wait()["StatusCode"]


def main(args: ArgumentParser) -> int:
    ret: int = 0

    print(ascii_art("BYOVM"))

    try:
        user_config: dict = get_user_config(questions)

        conf: config.Config = config.Config()

        create_build_dir(conf.out_path)

        copy: bool = setup_user_config(conf, user_config)
        iso_path: pathlib.Path = pathlib.Path(user_config[vars.iso_path])

        if copy:
            copy_file(iso_path, conf.out_path.absolute())

        else:
            print(
                f"The path: {conf.out_path.joinpath(iso_path.name)} already exists."
            )

        create_var_file(conf, user_config, str(conf.out_path.absolute()))

        env_dict: dict = export_env_vars(user_config, conf.exportable_vars,
                                         args.verbose)
        exceptions: list = [
            user_config[vars.vm_name], f"{user_config[vars.vm_name]}.sha256"
        ]

        ret: int = vm_creation(conf, env_dict)

        clean_build_dir(conf, exceptions)

    except KeyboardInterrupt:
        print("The program is exiting.")
        exit(1)

    return ret
