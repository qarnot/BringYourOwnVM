packer {
  required_version = ">= 1.7.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0"
    }
    ansible = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

build {
  name = "linux-base"
  sources = ["source.qemu.linux"]

  provisioner "shell" {
    binary = false
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    inline = ["mkdir /job && chmod 667 /job"]
  }

  provisioner "file" {
    sources = [ "./files/" ]
    destination = "/job/"
  }

  provisioner "shell" {
    binary = var.binary
    scripts = var.scripts
    expect_disconnect = var.expect_disconnect
    pause_before = var.pause_before

    # still not perfect, use "local" to add logic and gain more genericity ?
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    environment_vars = ["SSH_USERNAME=${var.ssh_username}"]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    playbook_file    = "${path.root}/../playbooks/playbook-upgrade.yml"
    user             = "${var.ssh_username}"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    playbook_file    = "${path.root}/../playbooks/playbook-qarnot.yml"
    user             = "${var.ssh_username}"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }

  # provisioner "ansible" {
  #   ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
  #   playbook_file    = "${path.root}/../playbooks/playbook-cleanup.yml"
  #   user             = "${var.ssh_username}"
  # }

  post-processors {
    post-processor "checksum" {
      checksum_types = ["sha256"]
      output = "build/${var.vm_name}.sha256"
    }
    post-processor "manifest" {
    }
  }
}

build {
  name = "linux-overlay"
  sources = ["source.qemu.linux"]

  # provisioner "shell" {
  #   binary = false
  #   execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
  #   inline = ["mkdir /job && chmod 667 /job"]
  # }

  # provisioner "file" {
  #   sources = [ "./files/" ]
  #   destination = "/job/"
  # }

  provisioner "shell" {
    binary = var.binary
    scripts = var.scripts
    expect_disconnect = var.expect_disconnect
    pause_before = var.pause_before

    # still not perfect, use "local" to add logic and gain more genericity ?
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    environment_vars = ["SSH_USERNAME=${var.ssh_username}"]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    playbook_file    = "${path.root}/../playbooks/playbook-upgrade.yml"
    user             = "${var.ssh_username}"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    playbook_file    = "${path.root}/../playbooks/playbook-qarnot.yml"
    user             = "${var.ssh_username}"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }

  # provisioner "ansible" {
  #   ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
  #   playbook_file    = "${path.root}/../playbooks/playbook-cleanup.yml"
  #   user             = "${var.ssh_username}"
  # }

  post-processors {
    post-processor "checksum" {
      checksum_types = ["sha256"]
      output = "build/${var.vm_name}.sha256"
    }
    post-processor "manifest" {
    }
  }
}

build {
  name = "windows-base"
  sources = ["source.qemu.windows"]

  provisioner "windows-shell" {
    scripts = var.scripts
  }

  post-processors {
    post-processor "checksum" {
      checksum_types = ["sha256"]
      output = "build/${var.vm_name}.sha256"
    }
    post-processor "manifest" {
    }
  }
}
