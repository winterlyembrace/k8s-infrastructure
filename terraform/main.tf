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
  name   = "ubuntu-k8s.qcow2"
  pool   = "default"
  source = "/var/lib/libvirt/images/ubuntu-k8s.qcow2"
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
  source     = "./modules/kvm_instance"
  for_each   = merge(var.k8s_nodes)
  vm_name    = each.key
  cpu        = each.value.cpu
  ram        = each.value.ram
  ip_address = each.value.ip

  user_name = var.user_name
  ssh_key   = var.ssh_key

  network_id     = libvirt_network.k8s_net.id
  base_volume_id = libvirt_volume.ubuntu_base.id
}
