output "ansible_inventory" {
  value = {
    all = {
      vars = {
        ansible_user = "egor"
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
  }
}
