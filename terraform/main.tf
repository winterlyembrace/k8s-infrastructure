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



# Base image

resource "libvirt_volume" "ubuntu_base" {
  name = "noble-server-cloudimg-amd64.img"
  pool = "default"
  source = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"
  format = "qcow2"
}
