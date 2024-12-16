#!/usr/bin/python3

from distutils.dir_util import copy_tree
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
    scripts.append(vars.default_script_ansible)

    if user_config[vars.distro] != "debian":
        scripts.append(vars.default_script_cloud_init)
    user_config.update({vars.scripts: scripts})

    return None


def configure_playbooks_dir(user_config: dict, conf: config.Config) -> None:
    from distutils.dir_util import copy_tree

    playbooks = []

    if user_config[vars.playbooks_dir] == "":
        user_config.pop(vars.playbooks_dir)
    else:
        playbooks_dir_path = pathlib.Path(user_config[vars.playbooks_dir])
        playbooks = copy_tree(user_config[vars.playbooks_dir], conf.out_path.joinpath(playbooks_dir_path.name))
        playbooks = ["/" + item for item in playbooks]

    playbooks.append(vars.upgrade_playbook)
    playbooks.append(vars.qarnot_playbook)
    user_config.update({vars.playbooks: playbooks})

    return None


def prune_user_config(user_config: dict, conf: config.Config) -> bool:

    copy = configure_iso_path(user_config)

    configure_scripts_dir(user_config, conf)
    configure_playbooks_dir(user_config, conf)

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

    if vars.files_dir in user_config:
        files_dir_path = pathlib.Path(user_config[vars.files_dir])
        files = copy_tree(user_config[vars.files_dir], conf.out_path.joinpath(files_dir_path.name))
        user_config.update({vars.files_dir: "/" + str(conf.out_path.joinpath(files_dir_path.name))})

    if vars.preseed_path in user_config:
        preseed_path = pathlib.Path(user_config[vars.preseed_path])
        print(preseed_path)
        copy_file(preseed_path, conf.out_path.joinpath(preseed_path.name))
        user_config.update({vars.preseed_path: "/" + str(conf.out_path.joinpath(preseed_path.name))})
        user_config.update({vars.preseed_file: str(preseed_path.name)})

    if vars.cloud_init_path in user_config:
        cloud_init_path = pathlib.Path(user_config[vars.cloud_init_path])
        cloud_inits = copy_tree(cloud_init_path, conf.out_path.joinpath(cloud_init_path.name))
        user_config.update({vars.cloud_init_path: "/" + str(conf.out_path.joinpath(cloud_init_path.name))})

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
    image = client.images.pull(conf.repo, tag=conf.tag)
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
