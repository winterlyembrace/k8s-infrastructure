# k8s-infrastructure
K8s cluster provisioning and management (IaC, Configuration Management, Bootstrap)

This repository contains the Infrastructure as Code (IaC) and configuration management for a multi-node Kubernetes cluster running on Libvirt/KVM virtual machines.

Work in Progress...

🏗 Architecture

The setup follows a classic modular approach:

    Provisioning: Terraform (Libvirt provider)

    OS Configuration: Ansible

    Cluster Orchestration: Kubeadm

    Networking (CNI): Calico

    Ingress: Nginx Ingress Controller
