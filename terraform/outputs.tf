# Output an Ansible-compatible inventory structure in JSON format
output "ansible_inventory" {
  description = "Ansible inventory in JSON format"
  value = {
    all = {
      vars = {
        ansible_user = var.user_name
      }
      children = {
	# Master nodes group: filtered by "master-" prefix
        masters = {
          hosts = {
            for name, config in local.k8s_nodes : name => {
              ansible_host = config.external_ip # IP for Ansible to connect via SSH
              internal_ip  = config.internal_ip # Private IP for K8s cluster communication
            } if startswith(name, "master")
          }
        }
	# Worker nodes group: filtered by "worker-" prefix
        workers = {
          hosts = {
            for name, config in local.k8s_nodes : name => {
              ansible_host = config.external_ip # IP for Ansible to connect via SSH
              internal_ip  = config.internal_ip # Private IP for K8s cluster communication
            } if startswith(name, "worker")
          }
        }
      }
    }
  }
}
