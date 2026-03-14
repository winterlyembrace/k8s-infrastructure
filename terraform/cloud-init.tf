resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)

  name = "commoninit-${each.key}.iso"
  pool = "default" 

  user_data = templatefile("${path.module}/templates/user-data.tftpl", {
    hostname      = each.key 
    ssh_key       = var.ssh_public_key
    password_hash = var.user_password_hash
  })

  network_config = templatefile("${path.module}/templates/network-config.tftpl", {
    ip_address = each.value.ip
    gateway    = each.key == "router" ? null : "192.168.100.2"
  })

  meta_data = jsonencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })
}
