variable "vm_name" { type = string }
variable "cpu" { type = number }
variable "ram" { type = number }
variable "ip_address" { type = string }
variable "network_id" { type = string }
variable "base_volume_id" { type = string }

variable "gateway" {
  type    = string
  default = null
}

variable "as_number" {
  type    = number
  default = null
}

variable "wan" {
  type    = bool
  default = false
}

variable "ext_ip" {
  type    = string
  default = null
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "host_ca_key_path" {
  type = string
}

variable "user_ca_pub_path" {
  type = string
}


