resource "libvirt_volume" "disk" {
  for_each = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)

  name           = "disk-${each.key}.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10 * 1024 * 1024 * 1024
}
