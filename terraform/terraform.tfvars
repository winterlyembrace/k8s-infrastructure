user_name = "egor"

master_count = 1

worker_count = 2

node_configs = {
  "master" = {
    cpu       = 2
    ram       = 2048
    disk_size = 15
    wan       = true
  }

  "worker" = {
    cpu       = 4
    ram       = 3072
    disk_size = 15
    wan       = true
  }
}
