resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    router_external_ip = "192.168.122.252" 
    nodes     = var.k8s_nodes          
  })
  filename = "../ansible/inventory.ini"
}
