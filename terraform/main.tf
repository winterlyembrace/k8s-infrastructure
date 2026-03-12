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
  count = 3 
  name = "commoninit-${count.index}.iso"
  pool = "default" 
  user_data = file("${path.module}/cloud_init.tftpl", {
    ssh_key = var.ssh_public_key
    })

  meta_data = jsonencode({
    "instance-id"    = "internal-vm-${count.index}"
    "local-hostname" = "internal-vm-${count.index}"
  })
}


# 1. Network
resource "libvirt_network" "internal_net" {
  name      = "my_internal_network"
  mode      = "nat" 
  addresses = ["192.168.100.0/24"]
  autostart = true

  dhcp {
    enabled = false
  }

  dns {
    enabled = false
  }
}

# 2. Base image

resource "libvirt_volume" "ubuntu_base" {
  name = "noble-server-cloudimg-amd64.img"
  pool = "default"
  source = "/var/lib/libvirt/images/noble-server-cloudimg-amd64.img"
  format = "qcow2"
}

# 3. Disks
resource "libvirt_volume" "vm_disk" {
  count          = 3 
  name           = "vm-disk-${count.index}.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10 * 1024 * 1024 * 1024
}

# 4. VMs
resource "libvirt_domain" "vm" {
  count  = 3 
  name   = "internal-vm-${count.index}"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    network_id = libvirt_network.internal_net.id
  }

  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
  }
}


