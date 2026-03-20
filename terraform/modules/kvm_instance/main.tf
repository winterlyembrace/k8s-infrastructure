terraform {
  required_version = "~> 1.7.0"
}

resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}-disk.qcow2"
  base_volume_id = var.base_volume_id
  format         = "qcow2"
  size           = var.disk_size * 1024 * 1024 * 1024
}

resource "tls_private_key" "host_key" {
  algorithm = "ED25519"
}

resource "null_resource" "sign_host_key" {
  triggers = {
    public_key = tls_private_key.host_key.public_key_openssh
    ip         = var.ip_address 
  }

  provisioner "local-exec" {
    command = <<EOT
      TMP_DIR=$(mktemp -d)
      echo "${tls_private_key.host_key.public_key_openssh}" > $TMP_DIR/host.pub
      ssh-keygen -s ${var.host_ca_key_path} -I "${var.vm_name}-cert" -h -n "${var.ip_address},${var.vm_name}" -V +52w $TMP_DIR/host.pub
      cp $TMP_DIR/host-cert.pub ${path.module}/signed_host_cert_${var.vm_name}.pub
      rm -rf $TMP_DIR
    EOT
  }
}

data "local_file" "host_cert" {
  filename   = "${path.module}/signed_host_cert_${var.vm_name}.pub"
  depends_on = [null_resource.sign_host_key]
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "init-${var.vm_name}.iso"
  pool      = "default"

  user_data = templatefile("${path.module}/templates/user-data.tftpl", {
    hostname = var.vm_name
    host_private_key = tls_private_key.host_key.private_key_openssh
    host_certificate = data.local_file.host_cert.content
    user_ca_pub      = file(var.user_ca_pub_path) 
  })

  network_config = templatefile("${path.module}/templates/network-config.tftpl", {
    ip_address     = var.ip_address
    gateway        = var.gateway
    ext_ip         = var.ext_ip 
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
