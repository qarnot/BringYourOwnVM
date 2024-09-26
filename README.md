# BringYourOwnVM

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

- `sources.pkr.hcl` : it contains the differents sources (configurations if you
prefer) which can possibly be built.

- `variables.pkr.hcl` : it contains all the variables definitions with their
types and default values which can be used in other template files. Defining
as many variables makes the template more generic as every defined variable can
be overwritten by the user in user-variable files located in `./vars`.
