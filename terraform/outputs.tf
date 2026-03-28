output "ansible_inventory" {
  value = {
    all = {
      vars = {
        ansible_user = "ubuntu"
        ansible_password = "ubuntu" 
      }
      children = {
        internal_network = {
          vars = {
            ansible_ssh_common_args = "-o ProxyJump=ubuntu@${module.kvm_instance["jump-server"].external_ip} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
          }
          children = {
            k8s_masters = {
              hosts = {
                for name, node in module.kvm_instance : name => {
                  ansible_host = node.internal_ip
                } if length(regexall("master", name)) > 0
              }
            }
            k8s_workers = {
              hosts = {
                for name, node in module.kvm_instance : name => {
                  ansible_host = node.internal_ip
                } if length(regexall("worker", name)) > 0
              }
            }
          }
        }
        jump_servers = {
          hosts = {
            jump-server = {
              ansible_host = try(module.kvm_instance["jump-server"].external_ip, null)
              ansible_ssh_common_args = "" 
            }
          }
        }
      }
    }
  }
}
