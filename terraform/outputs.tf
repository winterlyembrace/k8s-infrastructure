output "ansible_inventory" {
  value = {
    all = {
      vars = {
        ansible_user = var.user_name
      }
    }

    internal_network = {
      children = {
        for group in ["k8s_masters", "k8s_workers", "jump_servers"] : group => {}
      }
      vars = {
        ansible_ssh_common_args = "-o ProxyJump=${var.user_name}@${module.kvm_instance["jump-server"].external_ip} -o StrictHostKeyChecking=no"
      }
    }

    k8s_masters = {
      hosts = {
        for name, node in module.kvm_instance : name => {
          ansible_host = node.internal_ip
        }
        if length(regexall("master", name)) > 0
      }
    }

    k8s_workers = {
      hosts = {
        for name, node in module.kvm_instance : name => {
          ansible_host = node.internal_ip
        }
        if length(regexall("worker", name)) > 0
      }
    }

    jump_servers = {
      hosts = {
        jump-server = {
          ansible_host = try(module.kvm_instance["jump-server"].external_ip, null)
          internal_ip  = try(module.kvm_instance["jump-server"].internal_ip, null)
        }
      }
    }
  }
}
