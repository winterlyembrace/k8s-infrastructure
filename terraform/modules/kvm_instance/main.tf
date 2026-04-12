# Constrain the module to a specific Terraform version for consistency
terraform {
  required_version = "1.7.5"
}

# Create a unique storage volume for the VM by cloning the base image
resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}-disk.qcow2"
  base_volume_id = var.base_volume_id
  format         = "qcow2"
  size           = var.disk_size * 1024 * 1024 * 1024
}

# Generate a Cloud-Init ISO to automate OS configuration (users, networking, etc.)
resource "libvirt_cloudinit_disk" "commoninit" {
  name = "init-${var.vm_name}.iso"
  pool = "default"

  # Pass variables into the user-data template (SSH keys, usernames)	
  user_data = templatefile("${path.module}/templates/user-data.tftpl", {
    wan       = var.wan
    ssh_key   = var.ssh_key
    user_name = var.user_name
  })

  # Pass IP addresses into the network configuration template
  network_config = templatefile("${path.module}/templates/network-config.tftpl", {
    int_ip = var.int_ip
    ext_ip = var.ext_ip
  })

  # Define basic instance metadata like hostname
  meta_data = jsonencode({
    "instance-id"    = var.vm_name
    "local-hostname" = var.vm_name
  })
}

# Define the Virtual Machine (Domain) settings and resource attachments
resource "libvirt_domain" "node" {
  name   = var.vm_name
  vcpu   = var.cpu
  memory = var.ram

  # Attach the Cloud-Init disk created above
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  # Primary network interface (Internal/Isolated network)
  network_interface {
    network_id = var.network_id
  }

  # Conditional secondary network interface (WAN/External) using a dynamic block
  # This allows provisioning isolated VMs without direct internet access when var.wan is false.
  dynamic "network_interface" {
    for_each = var.wan ? [1] : []
    content {
      network_name = "default"
      addresses    = var.ext_ip != null ? [var.ext_ip] : null
    }
  }

  # Attach the main storage volume
  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  # Enable serial console access for troubleshooting
  console {
    type        = "pty"
    target_port = "0"
  }
}
