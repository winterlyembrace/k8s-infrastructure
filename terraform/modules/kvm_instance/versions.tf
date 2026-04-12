terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.7.0"
    }

    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.1"
    }
  }
}
