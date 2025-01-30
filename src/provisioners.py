from cli import vars

import json
import re


def add_provisioner(template_path: str, build_target: str, provisioner: str) -> None:

    try:
        with open(template_path, "r") as file:
            content = file.read()

        build_regex = rf"(build\s*\{{\s*name\s*=\s*\"{build_target}\".*?)(\n\}})"
        match = re.search(build_regex, content, re.DOTALL)

        if not match:
            print(f"Error: Build block with name '{build_target}' not found.")
            return

        build_block_start = match.group(
            1)  # Everything before the closing brace
        build_block_end = match.group(2)  # Closing brace of the build block

        updated_build_block = build_block_start + provisioner + build_block_end

        updated_content = content.replace(match.group(0), updated_build_block)

        with open(template_path, "w") as file:
            file.write(updated_content)

        print(
            f"Provisioner successfully added to build block '{build_target}' in '{template_path}'."
        )

    except Exception as e:
        print(f"Error: {e}")


def load_config_file(file: str) -> dict:
    user_config: dict = {}

    try:
        with open(file, "r", encoding="utf-8") as f:
            user_config: dict = json.load(f)
    except:
        print("Error: An error occured while reading the configuration.")
        exit(1)

    assert (f.closed)
    return user_config


def add_all_provisioners(template_path: str, config_path: str,
                                build_target: str) -> None:
    user_config: dict = load_config_file(config_path)

    if vars.scripts in user_config:
        scripts_provisioner: str = f"""
      provisioner "shell" {{
        binary = var.binary
        scripts = var.scripts
        expect_disconnect = var.expect_disconnect
        pause_before = var.pause_before
        execute_command = "echo '${{var.ssh_password}}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
        environment_vars = ["SSH_USERNAME=${{var.ssh_username}}"]
      }}
        """
        add_provisioner(template_path, build_target, scripts_provisioner)

    for playbook_path in user_config[vars.playbooks]:
        ansible_provisioner: str = f"""
      provisioner "ansible" {{
        ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
        playbook_file    = "{playbook_path}"
        user             = "${{var.ssh_username}}"
        extra_arguments  = ["--scp-extra-args", "'-O'"]
      }}
    """
        add_provisioner(template_path, build_target, ansible_provisioner)


    return None


if __name__ == "__main__":
    import sys

    add_all_provisioners(sys.argv[1], sys.argv[2], sys.argv[3])
