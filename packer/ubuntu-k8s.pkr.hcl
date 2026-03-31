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
  # Путь к твоему .img файлу
  iso_url          = "../noble-server-cloudimg-amd64.img"
  iso_checksum     = "sha256:7aa6d9f5e8a3a55c7445b138d31a73d1187871211b2b7da9da2e1a6cbf169b21"
  disk_image       = true
  
  output_directory = "./builds/"
  vm_name          = "ubuntu-k8s.qcow2"
  disk_size        = "15G"
  format           = "qcow2"
  accelerator      = "kvm"
  
  # Данные для подключения Packer к виртуалке
  ssh_username         = "egor"
  ssh_private_key_file = "/home/icyglocky/.ssh/id_ed25519"
  ssh_timeout          = "10m"

  # Создаем виртуальный CD-привод с конфигами (метод NoCloud)
  cd_files = [
    "./meta-data",
    "./user-data"
  ]
  cd_label = "cidata"

  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-display", "gtk"] # Убедись, что видишь окно QEMU, чтобы понимать, что происходит
  ]
}

build {
  sources = ["source.qemu.k8s_node"]

  # 1. Ждем, пока Cloud-init закончит настройку юзера и сети
  provisioner "shell" {
    inline = ["cloud-init status --wait"]
    valid_exit_codes = [0, 2]
  }

  # 2. Запускаем твой Ansible Playbook
  provisioner "ansible" {
    playbook_file = "../ansible/playbook-packer.yml"
    user          = "egor" # Важно: заходим под созданным юзером
    use_proxy     = false

    extra_arguments = [
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3",
      "--ssh-extra-args", "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    ]
  }

  # 3. Финальная очистка образа перед сохранением
  provisioner "shell" {
    inline = [
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt-get clean",
      "sudo cloud-init clean --logs --seed"
    ]
  }
}