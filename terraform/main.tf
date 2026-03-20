terraform {
  backend "http" {
  }
}


terraform {
  required_version = "~> 1.7.0"
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



resource "libvirt_volume" "ubuntu_base" {
  name   = "noble-server-cloudimg-amd64.img"
  pool   = "default"
  source = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"
  format = "qcow2"
}


resource "libvirt_network" "k8s_net" {
  name      = "k8s-isolated-net"
  mode      = "none"
  autostart = true

  dhcp {
    enabled = false
  }

  dns {
    enabled = false
  }
}



module "kvm_instance" {
  source   = "./modules/kvm_instance"
  for_each = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)

  vm_name    = each.key
  cpu        = each.value.cpu
  ram        = each.value.ram
  ip_address = each.value.ip
  as_number  = lookup(each.value, "as_number", null)

  wan    = lookup(each.value, "wan", false)
  ext_ip = lookup(each.value, "ext_ip", null)

  network_id     = libvirt_network.k8s_net.id
  base_volume_id = libvirt_volume.ubuntu_base.id

  gateway = each.key == "bastion" ? null : var.edge_nodes.bastion.ip
}
