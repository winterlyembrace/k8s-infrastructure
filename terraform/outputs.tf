output "ansible_inventory" {
  description = "Ansible inventory in JSON format"
  value = {
    all = {
      vars = {
        ansible_user = var.user_name
      }
      children = {
        masters = {
          hosts = {
            for name, config in local.k8s_nodes : name => {
              ansible_host = config.external_ip
              internal_ip  = config.internal_ip
            } if length(regexall("master", name)) > 0
          }
        }
        workers = {
          hosts = {
            for name, config in local.k8s_nodes : name => {
              ansible_host = config.external_ip
              internal_ip  = config.internal_ip
            } if length(regexall("worker", name)) > 0
          }
        }
      }
    }
  }
}