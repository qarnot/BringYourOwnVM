source "qemu" "qemu" {
  accelerator = "kvm"
  # still not perfect, use "local" to add logic and gain more genericity ?
  # boot_command = [
  #   "<wait><wait><wait><esc><wait><wait><wait>",
  #   "/install.amd/vmlinuz ",
  #   "initrd=/install.amd/initrd.gz ",
  #   "auto=true ",
  #   "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ",
  #   "hostname=${var.vm_name} ",
  #   "domain=${var.domain} ",
  #   "interface=auto ",
  #   "vga=788 noprompt quiet --<enter>"
  # ]
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
  http_content         = { "/${var.preseed_file}" = templatefile(var.preseed_file, { var = var }) }
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
  winrm_username               = "batman"
  winrm_password               = "batman"
  winrm_use_ssl                = true
  winrm_insecure               = true
  winrm_timeout                = "30m"
  pause_before_connecting      = "1m30s"
  qemuargs                     = var.qemuargs
  floppy_files                 = var.floppy_files
}

locals {
  output_directory = var.output_directory
}
