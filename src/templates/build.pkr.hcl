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
  name = "linux"
  sources = [
    "source.qemu.linux",
    "source.qemu.cloud"
  ]

  post-processors {
    post-processor "checksum" {
      checksum_types = ["sha256"]
      output = "build/${var.vm_name}.sha256"
    }
    post-processor "manifest" {
    }
  }
}
