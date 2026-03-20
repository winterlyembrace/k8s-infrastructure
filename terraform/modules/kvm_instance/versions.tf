terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }

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
