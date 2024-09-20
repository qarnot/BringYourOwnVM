# BringYourOwnVM

Every file with extension `.pkr.hcl` on the `master` branch are functional (with
more or less features) and can be run using the following commands:

```bash
packer init filename.pkr.hcl # This command installs the required plugins
packer build filename.pkr.hcl # This command runs the script
```
