output "ansible_inventory" {
  value = {
    all = {
      vars = {
        ansible_user            = "egor"
        jump_host_ip            = try(module.kvm_instance["bastion"].external_ip, null)
        ansible_ssh_common_args = try(
          "-o ProxyCommand=\"ssh -W %h:%p -q egor@${module.kvm_instance["bastion"].external_ip}\"", 
          ""
        )
      }
    }
    
    k8s_masters = {
      hosts = {
        for name, node in module.kvm_instance : name => { 
          ansible_host = node.internal_ip
          as_number    = node.as_number
        }
        if length(regexall("master", name)) > 0
      }
    }

    k8s_workers = {
      hosts = {
        for name, node in module.kvm_instance : name => { 
          ansible_host = node.internal_ip
          as_number    = node.as_number
        }
        if length(regexall("worker", name)) > 0
      }
    }

    infrastructure = {
      hosts = {
        for name, node in module.kvm_instance : name => { 
          ansible_host = node.internal_ip
          as_number    = node.as_number
        }
        if length(regexall("storage|logging", name)) > 0
      }
    }

    load_balancers = {
      hosts = {
        for name, node in module.kvm_instance : name => { 
          ansible_host = node.internal_ip
          as_number    = node.as_number
        }
        if length(regexall("lb", name)) > 0
      }
    }
    
    bastion = {
      hosts = {
        bastion = {
          ansible_host            = try(module.kvm_instance["bastion"].external_ip, null)
	  internal_ip             = try(module.kvm_instance["bastion"].internal_ip, null)
          ansible_ssh_common_args = "" 
          as_number               = try(module.kvm_instance["bastion"].as_number, 65000)
        }
      }
    }
  }
}
