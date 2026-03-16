variable "ssh_public_key" {
  description = "Public SSH key for user egor"
  type        = string
}



variable "k8s_nodes" {
  description = "Configuration for Kubernetes cluster nodes, including both control-plane and worker roles"
  type = map(object({
    cpu       = number
    ram       = number
    ip        = string
    as_number = number
    disk_size = optional (number, 10)
  }))
}



variable "edge_nodes" {
  description = "Configuration for boundary nodes (ingress controllers, bastions, or load balancers) that handle external traffic and connectivity"
  type = map(object({
    cpu       = number 
    ram       = number 
    ip        = string
    ext_ip    = string
    wan       = bool
    as_number = number
    disk_size = optional (number, 10)
  }))
}



variable "infra_nodes" {
  description = "Configuration for infrastructure services nodes (storage, monitoring, logging, etc.)"
  type = map(object({
    cpu       = number
    ram       = number
    ip        = string
    as_number = number
    disk_size = optional (number, 10)
  }))
}

variable "bastion_ext_ip" {
  description = "External bastion IP for Internet access"
  type = string
}
  
