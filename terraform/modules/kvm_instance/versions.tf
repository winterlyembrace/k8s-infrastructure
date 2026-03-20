terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~= 4.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~= 3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~= 2.0.0"
    }

    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~= 0.7.1"
    }
  }
}
