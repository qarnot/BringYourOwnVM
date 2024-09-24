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
    binary = false
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    environment_vars = [
      "SSH_USERNAME=${var.ssh_username}"
    ]
    scripts = [
      "scripts/script1.sh",
      "scripts/script2.sh"
    ]
  }
}
