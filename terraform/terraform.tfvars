

user_name = "egor"


k8s_nodes = {
  "master-01" = {
    cpu       = 2,
    ram       = 2048,
    ip        = "192.168.100.10"
  }

  "master-02" = {
    cpu       = 2,
    ram       = 2048,
    ip        = "192.168.100.11"
  }

  "master-03" = {
    cpu       = 2,
    ram       = 2048,
    ip        = "192.168.100.12"
  }

  "worker-01" = {
    cpu       = 1,
    ram       = 2048,
    ip        = "192.168.100.20"
  }

  "worker-02" = {
    cpu       = 2,
    ram       = 2048,
    ip        = "192.168.100.21"
  }
}


edge_nodes = {
  "jump-server" = {
    cpu       = 1,
    ram       = 512,
    ip        = "192.168.100.2",
    ext_ip    = "192.168.122.252"
    wan       = true
  }
}

