# Internal IP address for inter-node communication
output "internal_ip" {
  value = var.int_ip
}

# External (WAN) IP address for SSH and management access
output "external_ip" {
  value = var.ext_ip
}

# The system username assigned to this specific instance
output "user_name" {
  value = var.user_name
}
