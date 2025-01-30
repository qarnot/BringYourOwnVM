source "qemu" "linux" {
  accelerator = "kvm"
  boot_command                 = local.boot_command
  boot_wait                    = var.boot_wait
  cpus                         = var.cpus
  disk_interface               = var.disk_interface
  format                       = var.format
  headless                     = var.headless
  iso_checksum                 = var.iso_checksum
  iso_url                      = "${var.iso_path_external}/${var.iso_file}"
  memory                       = var.memory
  output_directory             = local.output_directory
  shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  ssh_password                 = var.ssh_password
  ssh_username                 = var.ssh_username
  ssh_timeout                  = var.ssh_timeout
  vm_name                      = var.vm_name
  http_content                 = local.http_content
  disk_size                    = "${var.disk_size}G"
  disk_image                   = var.disk_image
  communicator                 = var.communicator
  net_device                   = var.net_device
  qemu_binary                  = var.qemu_binary
}

source "qemu" "cloud" {
  accelerator                  = "kvm"
  cd_files                     = ["./provisions/cloud-init/*"]
  cd_label                     = "cidata"
  net_device                   = "virtio-net"
  disk_image                   = true
  disk_size                    = "${var.disk_size}G"
  iso_checksum                 = var.iso_checksum
  iso_url                      = "${var.iso_path_external}/${var.iso_file}"
  headless                     = var.headless
  format                       = var.format
  output_directory             = local.output_directory
  shutdown_command             = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_username                 = var.ssh_username
  ssh_private_key_file         = "/work/.ssh/id"
  ssh_timeout                  = var.ssh_timeout
  boot_wait                    = "20s"
  vm_name                      = var.vm_name
}


locals {
  output_directory = var.output_directory
  http_content = var.guest_os == "linux" && var.distro == "debian" ? {
    "/${var.preseed_file}" = templatefile(abspath(var.preseed_path), { var = var })
  } : {
    "/user-data" = file(abspath("${var.cloud_init_path}/user-data"))
    "/meta-data" = file(abspath("${var.cloud_init_path}/meta-data"))
  }
  boot_command = var.disk_image == false ? (
    var.guest_os == "linux" ? (
      var.distro == "debian" ? [
      "<wait><wait><wait><esc><wait><wait><wait>",
      "/install.amd/vmlinuz ",
      "initrd=/install.amd/initrd.gz ",
      "auto=true ",
      "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ",
      "hostname=${var.vm_name} ",
      "domain=${var.domain} ",
      "interface=auto ",
      "vga=788 noprompt quiet --<enter>"
    ] : [
      "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
      "e<wait>",
      "<down><down><down><end>",
      " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
      "<f10>"
    ]
  ) : null
  ) : null
}
