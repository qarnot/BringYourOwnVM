<a name="top"></a>




[![Qarnot](./assets/qarnot_banner.png "Qarnot")](https://qarnot.com)

# BringYourOwnVM

**BYOVM** is a PoC (Proof of Concept) tool built around [Packer](https://www.packer.io)
 which aims at demonstrating how can Packer be used to automate the creation of
 virtual machine images.

## Table of Contents

- [About](#about)
- [Usage](#usage)
- [How it Works](#how-it-works)
- [Run a task on Qarnot](#run-a-task-on-qarnot)
- [Current limitations](#current-limitations)
- [Licences](#licences)

## About <a name="about"></a>

The goal of this tool is to build virtual machine (VM) images which are
compatibles with [Qarnot](https://qarnot.com)'s HPC services.

This tool was designed by the ***Solution Team*** of [Qarnot computing](https://qarnot.com).

![BYOVM](./assets/byovm.gif "BYOVM")

## Usage

### Clone the sources

You need to have `git` pre-installed on your system.

```bash
git clone https://github.com/qarnot/bringyourownvm.git
```

### Install dependencies

To install the required dependencies for the tool to work:

1. create and use a virtual environment:

  - make sure Python is installed on the system: `python3 --version`
  - install the `python3-venv` package: `sudo apt install python3-venv`
  (for apt-based GNU/Linux distributions)
  - create a virtual environment: `python3 -m venv $PATH_TO_VENV`
  - activate the virtual environment: `source $PATH_TO_YOUR_VENV/bin/activate`
  - install the dependencies using `pip`: `pip install -r $PATH_TO_REQUIREMENTS_TXT`

To quit the virtual environment, simply type `deactivate` in the terminal.

### Run

If the dependencies are installed in a virtual environment, then it needs to be
activated each time the tool is launched: 

```bash
source $PATH_TO_YOUR_VENV/bin/activate
```

#### Using the CLI

By default, the tool will start by showing several questions  which are here to
help the user configure its virtual machine image.

```bash
python3 main.py
```

#### Using a pre-made configuration file

The tool can also be run directly using a configuration file. It will bypass the
questions and directly setup the directory and starts the Docker container.

```bash
python3 main.py -f $PATH_TO_THE_CONFIGURATION_FILE
```

In the end, the user would probably want to close the opened venv. To do so,
simply type: `deactivate` in the terminal.

## How it Works <a name="how-it-works"></a>

This tool uses [Packer](https://www.packer.io) and [Docker](https://www.docker.com/).
It wraps Packer and try to take advantage of its system of templates to be a
generic tool for creating virtual machine images. The tool was designed so
the the front-end part can be replaced or rewritten in another language. This
way, the tool becomes more portable and more adaptable.

**This tool will only work on operating systems using ***[systemd](https://systemd.io/)***!**

It will install a systemd service inside the VM image which will launch at every start-up.
It will try to establish a connection with other components available only on
the Qarnot infrastructure.

### CLI

The cli acts like a "front-end". It setups a configuration file in the JSON
format and groups all the user inputs into a specific directory. Then, it pulls
a Docker image and starts a container from it with the previously mentionned
directory mounted as a Docker volume.

Inside this container, Packer is launched and proceeds to the creation and
installation of the VM image.

### Provisioning a VM image

Provisioning a virtual machine image consists in providing some configuration
files in order to automatically install the OS and setup the VM.

To provision a VM image, the user can make use of several technologies:

- [preseed](https://wiki.debian.org/DebianInstaller/Preseed) (Debian only)

Preseeds are the official way to automate the Debian installation. It provides
answers to the questions asked by the installer.

- [autoinstall](https://canonical-subiquity.readthedocs-hosted.com/en/latest/intro-to-autoinstall.html) (Ubuntu only)

Preseeds were the official way to automate Ubuntu installation until Ubuntu 20.04.
Now, ***autoinstall*** is used, which is a sort of overload of [Cloud-Init](https://cloud-init.io/).

- [Ansible](https://www.ansible.com/) playbooks

Ansible is widely used to make idempotent configurations. It can be used to create users,
install packages ...

To make use of Ansible, the [Ansible plugin](https://github.com/hashicorp/packer-plugin-ansible)
for Packer is used.

**Warning: some edge cases may not work as the user would expect with the Ansible
plugin for Packer. For further information, please refer to the [official documentation
of the plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/ansible/latest/components/provisioner/ansible).**

- shell scripts

This wide range of technologies is designed to ensure that the tool fits
seamlessly in the user's workflow.

### Contracts

The following table summarizes all the possible variables with a description for each,
as well as whether it is mandatory or not.

| **Variable Name** | **Description** | **Mandatory** |
| ----------------- | --------------- | ------------- |
| os_guest          | operating system of the VM image |  YES          |
| disk_image | 'true' if the VM image already has an OS installed and at least one user setup, 'false' otherwise | YES |
| cloud_image | 'true' is the provided image is a cloud-image, 'false' otherwise | YES |
| vm_name | the name of the output VM image | NO |
|disk_size | the disk size to be allocated to the VM (minimum 10G) | NO |
| memory | the number of RAM which will be used to launch the VM for the installation (minimum 4G) | NO |
| cpus | the number of CPUs which will be used to launch the VM for the installation (minimum 4) | NO |
| ssh_username | the username of the user which will be used by Packer to connect to the VM through SSH. The user MUST already exist on the system. | YES |
| ssh_password | the password corresponding the username used by Packer to connect to the VM | YES |
| iso_path | the path on the host system to the ISO file (or the image) | NO |
| headless | MUST always be set to `true`, otherwise Docker will crash.  | NO |
| scripts | the list of pathes of scripts to be executed inside the Docker container | NO |
| iso_checksum | the checksum of the ISO file (or image)  | YES |
| iso_file | the name of the ISO file (or image)  | YES |
| iso_path_external | the parent path (the path without the name of the file) to the ISO file (or image) INSIDE the Docker container | YES |
| cloud_init_path | path to a directory containing cloud-init files `user-data` and `meta-data` (only for Ubuntu ISOs) | NO |
| playbook_files |  path to a directory containing all the playbook files the user wants to apply | YES |
| preseed_path | path to the preseed file (only work for Debian) | NO |
| root_enable | whether or not the root user is enabled (is not available for every distribution) | NO |
| root_password | password for the root user IF ROOT_ENABLE IS SET TO TRUE | NO |
| communicator | `ssh` for every Linux-related template | NO |

## Run a task on Qarnot <a name="run-a-task-on-qarnot"></a>

Further informations and detailed tutorials on how to use the Qarnot's compute
platform, please refer to the [official documentation](https://qarnot.com/documentation/en/home).

To run calculations on Qarnot using the freshly created VM image, the user can use the profile
`bring-your-own-vm-network`.

This profile defines the "contract" between the user and Qarnot services.

First, the user needs to upload his VM image inside a bucket on the Qarnot's platform.

The constants that are available are:

- `VM_USER`: the username of an existing VM user to log in using SSH.
- `VM_PASSWORD`: the password of the username.
- `VM_CMD`: the command to execute inside the VM.
- `VM_SHUTDOWN_CMD`: the command to properly shutdown the VM.
- `VM_IMAGE_PATH`: the name of the VM image to launch on the platform
- `VM_GUEST_OS_FAMILY`: "linux" or "windows".

A template to run a task using the Python SDK is available at `./profile_byovm.py`.

## Current limitations <a name="current-limitations"></a>

As this project is a PoC and not a final product, it still lacks of functionnality
and stability.

If you are encountering any issue regarding the use of this tool, please feel
free to open an issue on GitHub.

Some limitations/known issues:

- files cannot be copied by directly using Packer
- VNC through Docker to visualize the installation is currently not available.
- For now, the tool does not work for Windows
- This PoC has been tested mainly with Debian netiso Ubuntu 24.01 ISO and Ubuntu noble cloud image.
- As VNC is not available, it may be hard to debug. Most of the time, it comes from what is
provided to Packer (scripts, playbooks ...).

## Licences <a name="licences"></a>

This project is licenced under the terms of the Apache-2.0 license.

[Back to top](#top)
