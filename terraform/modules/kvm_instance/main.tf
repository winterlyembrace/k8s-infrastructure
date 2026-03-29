terraform {
  required_version = "~> 1.7.0"
}

resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}-disk.qcow2"
  base_volume_id = var.base_volume_id
  format         = "qcow2"
  size           = var.disk_size * 1024 * 1024 * 1024
}


resource "libvirt_cloudinit_disk" "commoninit" {
  name = "init-${var.vm_name}.iso"
  pool = "default"

  user_data = templatefile("${path.module}/templates/user-data.tftpl", {
    hostname       = var.vm_name
    authorized_key = var.ssh_key
    ssh_user       = var.user_name
  })

  network_config = templatefile("${path.module}/templates/network-config.tftpl", {
    ip_address = var.ip_address
  })

  meta_data = jsonencode({
    "instance-id"    = var.vm_name
    "local-hostname" = var.vm_name
  })
}

resource "libvirt_domain" "node" {
  name   = var.vm_name
  vcpu   = var.cpu
  memory = var.ram

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  console {
    type        = "pty"
    target_port = "0"
  }
}
