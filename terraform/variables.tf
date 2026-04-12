# The system username to be created and used inside all virtual machines
variable "user_name" {
  type = string
}

# Public SSH key to be injected into the virtual machines for the user_name account
variable "ssh_key" {
  description = "User's public SSH key"
  type        = string
  sensitive   = true
}

# Number of master nodes to provision in the cluster
variable "master_count" { type = number }

# Number of worker nodes to provision in the cluster
variable "worker_count" { type = number }

# Resource profiles for master and worker nodes
variable "node_configs" {
  type = map(object({
    cpu       = number
    ram       = number
    disk_size = number
    wan       = bool
  }))
}



