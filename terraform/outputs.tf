resource "local_file" "ansible_config" {
  content  = <<-EOT
    [defaults]
    inventory = inventory.ini
    host_key_checking = False
    remote_user = egor
    roles_path = ./roles

    [ssh_connection]
    pipelining = True
    ssh_args = -o ControlMaster=auto -o ControlPersist=60s
  EOT
  filename = "../ansible/ansible.cfg"
}


resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    router_external_ip = "192.168.122.252" 
    nodes     = merge(var.k8s_nodes, var.edge_nodes, var.infra_nodes)
  })
  filename = "../ansible/inventory.ini"
}
