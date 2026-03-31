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
    wan            = var.wan
    ssh_key        = var.ssh_key
    user_name      = var.user_name
  })

  network_config = templatefile("${path.module}/templates/network-config.tftpl", {
    int_ip = var.int_ip
    ext_ip = var.ext_ip
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

  network_interface {
    network_id = var.network_id
  }

  dynamic "network_interface" {
    for_each = var.wan ? [1] : []
    content {
      network_name = "default"
      addresses    = var.ext_ip != null ? [var.ext_ip] : null
    }
  }

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  console {
    type        = "pty"
    target_port = "0"
  }
}
