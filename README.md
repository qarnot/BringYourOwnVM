# BringYourOwnVM

## Goals

The goal of this tool is to build virtual machines (VM) which are compatibles
with Qarnot's HPC services.

## How to use it ?

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

### Build & Run

If the dependencies are installed in a virtual environment, then it needs to be
activated each time the tool is launched (pretty annoying ...): 

```bash
source $PATH_TO_YOUR_VENV/bin/activate
```

```bash
python3 main.py
```

In the end, the user would probably want to close the opened venv. To do so,
simply type: `deactivate` in the terminal.

## How it works

Once the tool is launched, follow the instructions. The tool creates a 
configuration file based on the user answers and fetchs the required data. A
Docker image is pulled and a container is launched using the newly-created
configuration file.

The Docker image uses [Packer](https://www.packer.io/), a tool used to automate
virtual machine image builds to build the virtual machine. A directory from the 
host is mounted inside the Docker container in order to share data such as
configuration file or any other inputs.

### Provisioning a VM (GNU/Linux-only)

Provisioning a virtual machine consists in providing some configuration files
in order to automatically install the OS and setup the VM.

To provision a VM, the user can make use of several technologies:
- [preseed](https://wiki.debian.org/DebianInstaller/Preseed) (Debian only)
- [cloud-init](https://cloudinit.readthedocs.io/en/latest/index.html) (Ubuntu only for now)
- shell scripts
- [Ansible](https://www.ansible.com/) playbooks

This wide range of technologies is designed to ensure that the tool fits
seamlessly in the user's workflow.

### Test

**During the development phase, the Docker image required for the tool to work
 is hosted on an internal registry (`docker-qlab.qarnot.net`), therefore the
 user must be logged in to the internal registry. See the `docker-login` man
 page for further information.**

For the sake of testing, some files are available in `src/demo/`:

- a `src/demo/debian.preseed` file, it is a generic template which you can
directly provide to the tool when creating a Debian VM
- `src/demo/cloud_init/`: some cloud-init files which will create a user
`ubuntu:ubuntu` and `boo:boobidou` (`username:password` format)
- `src/demo/files/`: a directory containing a C file with a fibonacci function,
this folder will be copied inside the VM providing some files at buildtime.

Some shell scripts are available in `src/provisions/scripts/linux`.

For now, the tested and usable ISOs are:
- Ubuntu 24.01 Desktop
- Ubuntu 24.01 Live-Server
- Debian 12.8.0 netinstall

## Run a task

To run a task using the freshly created VM, the user can use the profile
`bring-your-own-vm-network` (currently only available for the Solution team
 members).

This profile defines the "contract" between the user and Qarnot services.

First, the user needs to upload his VM inside a bucket on the Qarnot's platform.

The constants that are available are:

- `VM_USER`: the username of an existing VM user to log in using SSH.
- `VM_PASSWORD`: the password of the username.
- `VM_CMD`: the command to execute inside the VM.
- `VM_SHUTDOWN_CMD`: the command to properly shutdown the VM.
- `VM_IMAGE_PATH`: the path to the VM image inside the Docker container
(the content of the mounted bucket is be located in `/job/`)
- `VM_GUEST_OS_FAMILY`: "linux" or "windows".
- `DOCKER_REGISTRY_LOGIN`: the user login for the Docker registry.
- `DOCKER_REGISTRY_PASSWORD`: the user password for the Docker registry.

Other constants might be available with the forced constants priviledge.

## Current limitations

- At the time of writing, the tool does not work perfectly for Windows. It is
currently not possible to bring an already-made Windows VM.

## Known issues

- Windows support is not properly working for now: the provisioning phase is
not yet stable.
- Only few and ISO images are supported (netiso for Debian, Desktop and 
Live-Server for Ubuntu).
- VNC through Docker is currently not available.

For non-listed errors, please feel free to report them
at: `paul.fournillon@qarnot-computing.com` or to create an issue on the GitLab
repository.

## TODO

- [ ] Option to fetch some "default" ISOs
- [ ] Fix Ansible playbooks handling
- [ ] Support for Cloud images
- [ ] Finish Windows support
- [ ] VNC through Docker
- [ ] Improve code quality
- [ ] Improve compilation process (make it easier, make the final binary run
faster)
- [ ] Lighten the image
