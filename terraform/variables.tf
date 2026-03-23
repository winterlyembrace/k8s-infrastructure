variable "user_name" {
  type = string
}


variable "ssh_key" {
  description = "User's public SSH key"
  type        = string
  sensitive   = true
}


variable "k8s_nodes" {
  description = "Configuration for Kubernetes cluster nodes, including both control-plane and worker roles"
  type = map(object({
    cpu       = number
    ram       = number
    ip        = string
    disk_size = optional(number, 10)
  }))
}


variable "edge_nodes" {
  description = "Configuration for boundary nodes that handle external traffic and connectivity"
  type = map(object({
    cpu       = number
    ram       = number
    ip        = string
    ext_ip    = string
    wan       = bool
    disk_size = optional(number, 10)
  }))
}


