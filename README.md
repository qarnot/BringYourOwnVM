# BringYourOwnVM

## Build & Run

Every Packer files are located in the folder directory `./templates`. To
execute them, the only `./run.sh` script is needed.

```bash
./run.sh
# Initialize the Packer plugins
# Build the Packer templates in ./templates using a user-variables file located
# in ./vars
```

The Packer template is split in 3 differents files :

- `build.pkr.hcl`: it contains the definitions of some requirements such as the
Packer version, the required plugins as well as which sources should be built
and which provisioners should be called.

- `sources.pkr.hcl`: it contains the differents sources (configurations if you
prefer) which can possibly be built.

- `variables.pkr.hcl`: it contains all the variables definitions with their
types and default values which can be used in other template files. Defining
as many variables makes the template more generic as every defined variable can
be overwritten by the user in user-variable files located in `./vars`.

## Current Status

For now, this tool is able to:

- build a Linux VM image from ISO by specifing user-variables in the folder
`./vars`
- apply scripts on an already existing Linux VM image. The image on which apply
the scripts and the scripts to be applied as well as the ssh username and ssh
password need to be specified as user-variables in a file located in `./vars`

## TODO

- make it work for Windows (almost working for Windows Server 2019, still few
weird bugs with configuration scripts, will be fixed soon)

- setup the different Qarnot-specific configurations (network, daemon ...) for
both Windows and Linux

- make few quick tests for other Linux distributions

- improve the current template by using `local`: it allows to reference to
other variables (of type `variable`). A local variable can have as default
value a non-local variable (of type `variable`) while a non-local variable
cannot have another non-local variable as default value (weird HCL language
stuff I guess). TL;DR: we gain genericity, it's better.

- use containers

- optimize

- make tests

- make more tests

- fix bugs
