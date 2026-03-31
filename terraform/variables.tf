variable "user_name" {
  type = string
}

variable "ssh_key" {
  description = "User's public SSH key"
  type        = string
  sensitive   = true
}

variable "master_count" { type = number }
variable "worker_count" { type = number }

variable "node_configs" {
  type = map(object({
    cpu       = number
    ram       = number
    disk_size = number
    wan       = bool
  }))
  default = {
    "master" = { cpu = 2, ram = 1536, disk_size = 15, wan = true }
    "worker" = { cpu = 2, ram = 2048, disk_size = 15, wan = true }
  }
}



