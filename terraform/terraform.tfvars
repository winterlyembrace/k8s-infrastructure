# The login name to be created on every node (used by Ansible/SSH)
user_name = "egor"

# Total number of control-plane nodes
master_count = 3

# Total number of worker nodes
worker_count = 2 

# Hardware resource allocation per node role
node_configs = {
  "master" = {
    cpu       = 2
    ram       = 2048 # In Megabytes
    disk_size = 15   # In Gigabytes
    wan       = true # Enables external network access
  }

  "worker" = {
    cpu       = 4
    ram       = 2048 # In Megabytes
    disk_size = 15   # In Gigabytes
    wan       = true # Enables external network access
  }
}
