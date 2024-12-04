variable "apt_cache_url" {
  type = string
  default = "http://mydomain.eu/debian"
}

variable "boot_wait" {
  type    = string
  default = "3s"
}

variable "bundle_iso" {
  type    = string
  default = "false"
}

variable "communicator" {
  type    = string
  default = "ssh"
}

variable "country" {
  type    = string
  default = "FR"
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "description" {
  type    = string
  default = "x86_64 Debian Bookworm 12.x"
}

variable "disk_size" {
  type    = string
  default = "7500"
}

variable "domain" {
  type    = string
  default = ""
}

variable "guest_os" {
  type    = string
  default = "linux"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "host_port_max" {
  type    = string
  default = "4444"
}

variable "host_port_min" {
  type    = string
  default = "2222"
}

variable "http_port_max" {
  type    = string
  default = "9000"
}

variable "http_port_min" {
  type    = string
  default = "8000"
}

variable "iso_checksum" {
  type    = string
  default = "file:http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/SHA512SUMS"
}

variable "iso_file" {
  type    = string
  default = "debian-12.8.0-amd64-netinst.iso"
}

variable "iso_path_external" {
  type    = string
  default = "http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd"
}

variable "keep_registered" {
  type    = string
  default = "false"
}

variable "keyboard" {
  type    = string
  default = "fr"
}

variable "language" {
  type    = string
  default = "en"
}

variable "locale" {
  type    = string
  default = "en_US.UTF-8"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "mirror" {
  type    = string
  default = "ftp.fr.debian.org"
}

variable "packer_cache_dir" {
  type    = string
  default = "${env("PACKER_CACHE_DIR")}"
}

variable "preseed_file" {
  type    = string
  default = "debian.preseed"
}

variable "qemu_binary" {
  type    = string
  default = "qemu-system-x86_64"
}

variable "shutdown_timeout" {
  type    = string
  default = "5m"
}

variable "skip_export" {
  type    = string
  default = "false"
}

variable "ssh_agent_auth" {
  type    = string
  default = "false"
}

variable "ssh_clear_authorized_keys" {
  type    = string
  default = "false"
}

variable "ssh_disable_agent_forwarding" {
  type    = string
  default = "false"
}

variable "ssh_file_transfer_method" {
  type    = string
  default = "scp"
}

variable "ssh_fullname" {
  type    = string
  default = "Bruce Wayne"
}

variable "ssh_handshake_attempts" {
  type    = string
  default = "10"
}

variable "ssh_keep_alive_interval" {
  type    = string
  default = "5s"
}

variable "ssh_password" {
  type    = string
  default = "batman"
  sensitive = true
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "ssh_pty" {
  type    = string
  default = "false"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_username" {
  type    = string
  default = "batman"
}

variable "start_retry_timeout" {
  type    = string
  default = "5m"
}

variable "system_clock_in_utc" {
  type    = string
  default = "true"
}

variable "timezone" {
  type    = string
  default = "UTC"
}

variable "version" {
  type    = string
  default = "0.0.0"
}

variable "vm_name" {
  type    = string
  default = "qvm.qcow2"
}

variable "vnc_vrdp_bind_address" {
  type    = string
  default = "127.0.0.1"
}

variable "vnc_vrdp_port_max" {
  type    = string
  default = "6000"
}

variable "vnc_vrdp_port_min" {
  type    = string
  default = "5900"
}

variable "binary" {
  type = bool
  default = false
}

variable "scripts" {
  type = list(string)
  default = null
}

variable "skip_compaction" {
  type = bool
  default = true
}

variable "skip_nat_mapping" {
  type = bool
  default = false
}

variable "use_default_display" {
  type = bool
  default = false
}

variable "disk_cache" {
  type = string
  default = "writeback"
}

variable "disk_compression" {
  type = bool
  default = false
}

variable "disk_discard" {
  type = string
  default = "ignore"
}

variable "disk_image" {
  type = bool
  default = false
}

variable "disk_interface" {
  type = string
  default = "virtio-scsi"
}

variable "format" {
  type = string
  default = "qcow2"
}

variable "iso_skip_cache" {
  type = bool
  default = false
}

variable "iso_target_extension" {
  type = string
  default = "iso"
}

variable "machine_type" {
  type = string
  default = "pc"
}

variable "net_device" {
  type = string
  default = "virtio-net"
}

variable "output_directory" {
  type = string
  default = "build/"
}

variable "expect_disconnect" {
  type = bool
  default = true
}

variable "pause_before" {
  type = string
  default = "5s"
}

variable "floppy_files" {
  type = list(string)
  default = null
}

variable "http_dir" {
  type = string
  default = null
}

variable "floppy_dirs" {
  type = list(string)
  default = null
}

variable "qemuargs" {
  type = list(list(string))
  default = null
}

variable "root_password" {
  type = string
  default = "default"
}

variable "root_enable" {
  type = bool
  default = false
}
