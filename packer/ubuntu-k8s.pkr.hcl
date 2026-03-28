packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "k8s_node" {
  iso_url          = "${env("HOME")}/noble-server-cloudimg-amd64.img"
  iso_checksum     = "sha256:7aa6d9f5e8a3a55c7445b138d31a73d1187871211b2b7da9da2e1a6cbf169b21"
  disk_image       = true
  output_directory = "/var/lib/libvirt/images"
  vm_name          = "ubuntu-k8s.qcow2"
  disk_size        = "10G"
  format           = "qcow2"
  accelerator      = "kvm"
  
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"

  cd_files = [
    "./meta-data",
    "./user-data"
  ]
  cd_label = "cidata"

  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"]
  ]
}

build {
  sources = ["source.qemu.k8s_node"]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
    valid_exit_codes = [0, 2]
  }

  provisioner "ansible" {
    playbook_file = "../ansible/playbook-packer.yml"
    user          = "ubuntu"
    use_proxy     = false

    extra_arguments = [
        "--extra-vars", "ansible_password=ubuntu",
        "--extra-vars", "ansible_sudo_pass=ubuntu",
        "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
        "--ssh-extra-args", "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null",
        "--scp-extra-args", "'-O'"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo cloud-init clean --logs --seed",
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt-get clean"
    ]
  }
}