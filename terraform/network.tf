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
