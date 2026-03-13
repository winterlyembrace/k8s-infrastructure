resource "libvirt_domain" "vm" {
  for_each = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)

  name   = each.key
  vcpu   = each.value.cpu
  memory = each.value.ram

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id


  # Internal cluster network

  network_interface {
    network_id = libvirt_network.k8s_net.id
    addresses  = [each.value.ip]
  }


  # External network interface

  dynamic "network_interface" {
    for_each = lookup(each.value, "wan", false) ? [1] : []
    content {
      network_name = "default"
    }
  }

  
  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  console {
    type        = "pty"
    target_port = "0"
  }
}


