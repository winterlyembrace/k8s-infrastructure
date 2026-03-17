k8s_nodes = {
  "k8s-master" = { 
    cpu = 2, 
    ram = 1536, 
    ip = "192.168.100.10", 
    as_number = 64512,
  }
  "worker-01" = { 
    cpu = 1, 
    ram = 1024, 
    ip = "192.168.100.20", 
    as_number = 64513 
  }
  
  "worker-02" = { 
    cpu = 1, 
    ram = 1024, 
    ip = "192.168.100.21", 
    as_number = 64513 
  }
}

infra_nodes = {
  "storage" = { 
    cpu = 1, 
    ram = 512, 
    ip = "192.168.100.40", 
    as_number = 64516 
  }
  "logging" = { 
    cpu = 1, 
    ram = 512, 
    ip = "192.168.100.41", 
    as_number = 64516 
  }
}

edge_nodes = {
  "bastion" = { 
    cpu = 1, 
    ram = 512, 
    ip = "192.168.100.2",
    ext_ip = "192.168.122.252"
    wan = true, 
    as_number = 64514
  }
  
  "lb-01"   = { 
    cpu = 1, 
    ram = 512, 
    ip = "192.168.100.30",
    ext_ip = "192.168.122.253"
    wan = true, 
    as_number = 64515 }
}

