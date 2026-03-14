output "router_external_ip" {
  value = libvirt_domain.nodes["router"].network_interface[0].addresses[0]
}
