packer {
  required_version = ">= 1.7.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0"
    }
  }
}

build {
  sources = ["source.qemu.qemu"]

  provisioner "shell" {
    binary = var.binary
    scripts = var.scripts
    expect_disconnect = var.expect_disconnect
    pause_before = var.pause_before

    # still not perfect, use "local" to add logic and gain more genericity ?
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    environment_vars = ["SSH_USERNAME=${var.ssh_username}"]
  }
}
