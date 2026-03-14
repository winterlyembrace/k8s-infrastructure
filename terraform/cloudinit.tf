resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)

  name = "commoninit-${each.key}.iso"
  pool = "default" 

  user_data = templatefile("${path.module}/cloud_init.tftpl", {
    hostname      = each.key 
    ssh_key       = var.ssh_public_key
    password_hash = var.user_password_hash
  })

  network_config = templatefile("${path.module}/network_config.tftpl", {
    ip_address = each.value.ip
  })

  meta_data = jsonencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })
}
