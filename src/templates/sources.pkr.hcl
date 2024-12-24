source "qemu" "generic" {
  accelerator = "kvm"
  # still not perfect, use "local" to add logic and gain more genericity ?
  boot_command = [
    "<wait><wait><wait><esc><wait><wait><wait>",
    "/install.amd/vmlinuz ",
    "initrd=/install.amd/initrd.gz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ",
    "hostname=${var.vm_name} ",
    "domain=${var.domain} ",
    "interface=auto ",
    "vga=788 noprompt quiet --<enter>"
  ]
  boot_wait            = var.boot_wait
  communicator         = var.communicator
  cpus                 = var.cpus
  disk_cache           = var.disk_cache
  disk_compression     = var.disk_compression
  disk_discard         = var.disk_discard
  disk_image           = var.disk_image
  disk_interface       = var.disk_interface
  disk_size            = var.disk_size
  format               = var.format
  headless             = var.headless
  host_port_max        = var.host_port_max
  host_port_min        = var.host_port_min
  http_content         = local.http_content
  http_port_max        = var.http_port_max
  http_port_min        = var.http_port_min
  iso_checksum         = var.iso_checksum
  iso_skip_cache       = var.iso_skip_cache
  iso_target_extension = var.iso_target_extension
  iso_url = "${var.iso_path_external}/${var.iso_file}"
  machine_type                 = var.machine_type
  memory                       = var.memory
  net_device                   = var.net_device
  output_directory             = local.output_directory
  qemu_binary                  = var.qemu_binary
  # still not perfect, use "local" to add logic and gain more genericity ?
  # shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  shutdown_timeout             = var.shutdown_timeout
  skip_compaction              = var.skip_compaction
  skip_nat_mapping             = var.skip_nat_mapping
  ssh_agent_auth               = var.ssh_agent_auth
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = var.ssh_file_transfer_method
  ssh_handshake_attempts       = var.ssh_handshake_attempts
  ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  ssh_password                 = var.ssh_password
  ssh_port                     = var.ssh_port
  ssh_pty                      = var.ssh_pty
  ssh_timeout                  = var.ssh_timeout
  ssh_username                 = var.ssh_username
  use_default_display          = var.use_default_display
  vm_name                      = var.vm_name
  vnc_bind_address             = var.vnc_vrdp_bind_address
  vnc_port_max                 = var.vnc_vrdp_port_max
  vnc_port_min                 = var.vnc_vrdp_port_min

  shutdown_command             = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  winrm_username               = "packer"
  winrm_password               = "packer"
  winrm_use_ssl                = true
  winrm_insecure               = true
  # winrm_timeout                = "5m"
  pause_before_connecting      = "1m30s"
  # pause_before_connecting      = "1s"
  qemuargs                     = var.qemuargs
  floppy_files                 = var.floppy_files
}

source "qemu" "linux" {
  accelerator = "kvm"
  boot_command         = local.boot_command
  boot_wait            = var.boot_wait
  cpus                 = var.cpus
  disk_interface       = var.disk_interface
  format               = var.format
  headless             = var.headless
  iso_checksum         = var.iso_checksum
  iso_url = "${var.iso_path_external}/${var.iso_file}"
  memory                       = var.memory
  output_directory             = local.output_directory
  # still not perfect, use "local" to add logic and gain more genericity ?
  shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  ssh_password                 = var.ssh_password
  ssh_username                 = var.ssh_username
  ssh_timeout                  = var.ssh_timeout
  vm_name                      = var.vm_name
  http_content                 = local.http_content
  # communicator                 = var.communicator
  # disk_size            = "${var.disk_size}G"
  # disk_image                   = var.disk_image
  # host_port_max                = var.host_port_max
  # host_port_min                = var.host_port_min
  # net_device                   = var.net_device
  # qemu_binary                  = var.qemu_binary
  # shutdown_timeout             = var.shutdown_timeout
  # ssh_port                     = var.ssh_port
  # ssh_pty                      = var.ssh_pty
  # ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  # ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  # ssh_file_transfer_method     = var.ssh_file_transfer_method
  # ssh_handshake_attempts       = var.ssh_handshake_attempts
  # ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  # iso_skip_cache               = var.iso_skip_cache
  # disk_cache                   = var.disk_cache
  # disk_compression             = var.disk_compression
  # disk_discard                 = var.disk_discard
  # machine_type                 = var.machine_type
  # skip_compaction              = var.skip_compaction
  # skip_nat_mapping             = var.skip_nat_mapping
  # ssh_agent_auth               = var.ssh_agent_auth
  # use_default_display          = var.use_default_display
  # iso_target_extension         = var.iso_target_extension
  # vnc_bind_address             = var.vnc_vrdp_bind_address
  # vnc_port_max                 = var.vnc_vrdp_port_max
  # vnc_port_min                 = var.vnc_vrdp_port_min
}

source "qemu" "windows" {
  accelerator = "kvm"
  # boot_wait            = var.boot_wait
  communicator         = var.communicator
  cpus                 = var.cpus
  disk_cache           = var.disk_cache
  disk_compression     = var.disk_compression
  disk_discard         = var.disk_discard
  disk_image           = var.disk_image
  disk_interface       = var.disk_interface
  disk_size            = "${var.disk_size}G"
  format               = var.format
  headless             = var.headless
  # http_content         = local.http_content
  http_directory       = var.http_dir
  host_port_max        = var.host_port_max
  host_port_min        = var.host_port_min
  http_port_max        = var.http_port_max
  http_port_min        = var.http_port_min
  iso_checksum         = var.iso_checksum
  iso_skip_cache       = var.iso_skip_cache
  iso_target_extension = var.iso_target_extension
  iso_url = "${var.iso_path_external}/${var.iso_file}"
  machine_type                 = var.machine_type
  memory                       = var.memory
  net_device                   = var.net_device
  output_directory             = local.output_directory
  qemu_binary                  = var.qemu_binary
  shutdown_timeout             = var.shutdown_timeout
  skip_compaction              = var.skip_compaction
  skip_nat_mapping             = var.skip_nat_mapping
  # ssh_agent_auth               = var.ssh_agent_auth
  # ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  # ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  # ssh_file_transfer_method     = var.ssh_file_transfer_method
  # ssh_handshake_attempts       = var.ssh_handshake_attempts
  # ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  # ssh_password                 = var.ssh_password
  # ssh_port                     = var.ssh_port
  # ssh_pty                      = var.ssh_pty
  # ssh_timeout                  = var.ssh_timeout
  # ssh_username                 = var.ssh_username
  use_default_display          = var.use_default_display
  vm_name                      = var.vm_name
  vnc_bind_address             = var.vnc_vrdp_bind_address
  vnc_port_max                 = var.vnc_vrdp_port_max
  vnc_port_min                 = var.vnc_vrdp_port_min

  shutdown_command             = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  # winrm_username               = "Administrator"
  # winrm_password               = "Administrator"
  winrm_username               = "packer"
  winrm_password               = "packer"
  winrm_use_ssl                = true
  winrm_insecure               = true
  winrm_timeout                = "60m"
  pause_before_connecting      = "1m30s"
  qemuargs                     = var.qemuargs
  # floppy_files                 = var.floppy_files
  # floppy_dirs                  = var.floppy_dirs
}

locals {
  output_directory = var.output_directory
  http_content = var.guest_os == "linux" && var.distro == "debian" ? {
    "/${var.preseed_file}" = templatefile(abspath(var.preseed_path), { var = var })
  } : {
    "/user-data" = file(abspath("${var.cloud_init_path}/user-data"))
    "/meta-data" = file(abspath("${var.cloud_init_path}/meta-data"))
    # "/network-data" = file("${var.cloud_init_path}/network-data")
  }
  # http_content = var.distro == "debian" ? (
  # var.cloud_init_path != null ? {
  # "/${var.preseed_file}" = templatefile(abspath(var.preseed_path), { var = var })
  # "/user-data" = file(abspath("${var.cloud_init_path}/user-data"))
  # "/meta-data" = file(abspath("${var.cloud_init_path}/meta-data"))
  # # "/network-data" = file("${var.cloud_init_path}/network-data")
  #     } : { "/${var.preseed_file}" = templatefile(abspath(var.preseed_path), { var = var }) }
  # ) : {
  #     "/user-data" = file(abspath("${var.cloud_init_path}/user-data"))
  #     "/meta-data" = file(abspath("${var.cloud_init_path}/meta-data"))
  #     # "/network-data" = file("${var.cloud_init_path}/network-data")   
  # }
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
