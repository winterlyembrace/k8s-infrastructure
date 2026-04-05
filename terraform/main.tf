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

locals {
  k8s_nodes = merge(
    { for i in range(var.master_count) : format("master-%02d", i + 1) => {
        cpu         = var.node_configs["master"].cpu
        ram         = var.node_configs["master"].ram
        disk_size   = var.node_configs["master"].disk_size
        wan         = var.node_configs["master"].wan
        internal_ip = "192.168.100.${10 + i}"
        external_ip = "192.168.122.${10 + i}"
    }},
    { for i in range(var.worker_count) : format("worker-%02d", i + 1) => {
        cpu         = var.node_configs["worker"].cpu
        ram         = var.node_configs["worker"].ram
        disk_size   = var.node_configs["worker"].disk_size
        wan         = var.node_configs["worker"].wan
        internal_ip = "192.168.100.${20 + i}"
        external_ip = "192.168.122.${20 + i}"
    }}
  )
}

module "kvm_instance" {
  source       = "./modules/kvm_instance"
  for_each     = local.k8s_nodes
  vm_name      = each.key
  cpu          = each.value.cpu
  ram          = each.value.ram
  int_ip       = each.value.internal_ip
  ext_ip       = each.value.external_ip
  disk_size    = each.value.disk_size

  user_name = var.user_name
  ssh_key   = var.ssh_key
  wan       = each.value.wan
  

  network_id     = libvirt_network.k8s_net.id
  base_volume_id = libvirt_volume.ubuntu_base.id
}
