resource "libvirt_network" "k8s_net" {
  name      = "k8s-isolated-net"
  mode      = "none"
  domain    = "k8s.local"
  addresses = ["192.168.100.0/24"]
  autostart = true

  dhcp {
    enabled = false
  }

  dns {
    enabled = false
  }
}
