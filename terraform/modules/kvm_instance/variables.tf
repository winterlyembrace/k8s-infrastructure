variable "vm_name" { type = string }
variable "cpu" { type = number }
variable "ram" { type = number }
variable "ip_address" { type = string }
variable "network_id" { type = string }
variable "base_volume_id" { type = string }
variable "user_name" { type = string }


variable "disk_size" {
  type    = number
  default = 15
}

variable "ssh_key" {
  type      = string
  sensitive = true
}



