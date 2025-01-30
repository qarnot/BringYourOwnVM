variable "boot_wait" {
  type    = string
  default = "5s"
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
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "10G"
}

variable "guest_os" {
  type    = string
  default = "linux"
}

variable "distro" {
  type    = string
  default = ""
}

variable "headless" {
  type    = string
  default = "true"
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
  default = "5120"
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

variable "ssh_file_transfer_method" {
  type    = string
  default = "scp"
}

variable "ssh_fullname" {
  type    = string
  default = "username"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_password" {
  type    = string
  default = "ubuntu"
  sensitive = true
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
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

variable "vm_name" {
  type    = string
  default = "qvm.qcow2"
}

variable "binary" {
  type = bool
  default = false
}

variable "scripts" {
  type = list(string)
  default = null
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

variable "files_dir" {
  type = string
  default = null
}

variable "cloud_init_path" {
  type = string
  default = "./provisions/cloud-init"
}

variable "playbook_files" {
  type = list(string)
  default = null
}

variable "preseed_path" {
  type = string
  default = null
}
