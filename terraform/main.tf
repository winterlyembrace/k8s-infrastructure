terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}



resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)

  name = "commoninit-${each.key}.iso"
  pool = "default" 

  user_data = templatefile("${path.module}/cloud_init.tftpl", {
    hostname      = each.key 
    ssh_key       = var.ssh_public_key
    password_hash = var.user_password_hash
  })

  meta_data = jsonencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })
}



# Base image

resource "libvirt_volume" "ubuntu_base" {
  name = "noble-server-cloudimg-amd64.img"
  pool = "default"
  source = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"
  format = "qcow2"
}
