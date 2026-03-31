variable "vm_name" { type = string }
variable "cpu" { type = number }
variable "ram" { type = number }
variable "int_ip" { type = string }
variable "ext_ip" { type = string }
variable "network_id" { type = string }
variable "base_volume_id" { type = string }
variable "user_name" { type = string }

variable "wan" {
  type    = bool
  default = true
}

variable "disk_size" {
  type    = number
  default = 15
}

variable "ssh_key" {
  type      = string
  sensitive = true
}



