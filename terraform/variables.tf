variable "ssh_public_key" {
  description = "Public SSH key for user egor"
  type        = string
}

variable "user_password_hash" {
  description = "Password hash for logging into VMs"
  type	      = string
}


# Kubernetes cluster

variable "k8s_nodes" {
  type = map(object({
    cpu = number
    ram = number
    ip  = string
  }))
  default = {
    "master-01" = { cpu = 2, ram = 1536, ip = "192.168.100.10" }
    "worker-01" = { cpu = 1, ram = 1024, ip = "192.168.100.20" }
    "worker-02" = { cpu = 1, ram = 1024, ip = "192.168.100.21" }
  }
}


# Router & Load Balancer

variable "edge_nodes" {
  type = map(object({
    cpu = number, ram = number, ip  = string, wan = bool
  }))
  default = {
    "router" = { cpu = 1, ram = 512, ip = "192.168.100.2", wan = true }
    "lb-01" = { cpu = 1, ram = 512, ip = "192.168.100.30", wan = false }
  }
}


# Storage

variable "infra_nodes" {
  type = map(object({
    cpu = number, ram = number, ip = string
  }))
  default = {
    "storage" = { cpu = 1, ram = 512, ip = "192.168.100.40" }
  }
}
