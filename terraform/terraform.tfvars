user_name = "egor"

master_count = 3

worker_count = 1

node_configs = {
  "master" = {
    cpu       = 2
    ram       = 2048
    disk_size = 15
    wan       = true
  }

  "worker" = {
    cpu       = 4
    ram       = 2048
    disk_size = 15
    wan       = true
  }
}
