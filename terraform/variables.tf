variable "ssh_public_key" {
  description = "Public SSH key for user egor"
  type        = string
}

variable "user_password_hash" {
  description = "Password hash for logging into VMs"
  type	      = string
}
