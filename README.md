# k8s-infrastructure

Kubernetes Bare-Metal Infrastructure provisioning and management (IaC, High Availability, Immutable Infrastructure)

## 🧩 The Ecosystem
This project is part of a distributed GitOps architecture across several repositories:
* **Infrastructure (This Repo):** Bare-metal provisioning with Terraform, Ansible, and Packer.
* **[GitOps Config](https://github.com/winterlyembrace/k8s-gitops-config):** Cluster state, FluxCD manifests, and Helm releases.
* **[CI Tooling](https://github.com/winterlyembrace/ci-toolkit)**: Optimized build images (Kaniko, Trivy).
* **[Demo Application](https://github.com/winterlyembrace/chpod)**: The source code for the Full-stack App (Python + React).

This repository contains a complete Infrastructure as Code (IaC) and Gitlab CI workflow to provision and manage a highly available multi-node Kubernetes cluster from scratch on Libvirt/KVM virtual machines.

The project covers everything from machine image creation to application deployment via GitOps, ensuring a fully automated "zero-to-cluster" experience.

🚀 Project Architecture

```mermaid
graph TD
    %% Определение внешних сущностей
    Admin((Admin/CI))
    User((User))

    subgraph Provisioning [Provisioning Phase]
        P[Packer]
        TF[Terraform]
        AN[Ansible]
    end

    subgraph Cluster [Bare-Metal Cluster]
        subgraph CP [Control Plane HA]
            VIP["Virtual IP (Keepalived)"]
            LB[HAProxy]
            M1[Master 1]
            M2[Master 2]
            M3[Master 3]
            
            VIP --> LB
            LB --> M1 & M2 & M3
        end
        
        subgraph DP [Data Plane]
            W1[Worker 1]
            W2[Worker 2]
            Cilium["Cilium (L2 Announce / GW API)"]
            
            W1 & W2 --- Cilium
        end

        Flux[FluxCD]
    end

    %% Связи между фазами
    P -->|Images| Cluster
    TF -->|VMs & Network| Cluster
    AN -->|Kubeadm Bootstrap| Cluster

    %% Потоки управления и трафика
    Admin -->|kubectl| VIP
    Flux -->|Sync Manifests| VIP
    User -->|HTTP/App Traffic| Cilium
    
    %% Стилизация
    style VIP fill:#f9f,stroke:#333,stroke-width:2px
    style Cilium fill:#bbf,stroke:#333,stroke-width:2px
    style Provisioning fill:#f5f5f5,stroke:#d3d3d3,stroke-dasharray: 5 5
```

The deployment is split into three main phases:


Image Provisioning (Packer)

Packer is used to build optimized Debian/Ubuntu images.

Pre-installed dependencies: kubeadm, kubelet and container runtime (containerd).

Ensures consistent environments across all nodes and speeds up cluster bootstrapping.


Infrastructure & Bootstrapping (Terraform & Ansible)

Terraform: Provisions the underlying virtual infrastructure (virtual machines, networking, storage).

Ansible: Configures HAProxy and Keepalived to provide a High Availability Control Plane consisting of 3 master nodes. Executes kubeadm init and joins worker nodes. Deploys Cilium as the CNI for high-performance networking and security.

GitLab CI: Orchestrates the entire flow, from Terraform plan/apply to Ansible playbooks.


GitOps & Application Layer (FluxCD)

Once the cluster is live, FluxCD from another repository (https://github.com/winterlyembrace/k8s-gitops-config) takes over to manage cluster state:

Cilium L2 Announcement: Configured for local network accessibility.

Workloads: Automatic deployment of a full-stack application (Frontend + Backend).

Modern Ingress: Implemented via Cilium Gateway API (HTTPRoute) for advanced L7 traffic management and service exposure.

Synchronization: Ensures the cluster state always matches the configuration in the Git repository.


🛠 Tech Stack


IaC: Terraform, Packer


Configuration Management: Ansible


Orchestration: Kubernetes (kubeadm)


Networking: Cilium (CNI), HAProxy, Keepalived, Gateway API


CI/CD: GitLab CI, FluxCD


Platform: KVM/libvirt (Bare-Metal)


🗺 Roadmap & Future Enhancements


[ ] Pure GitOps Infrastructure: Migrate from GitLab CI/Ansible to a Tofu-controller (OpenTofu) managed from a dedicated Management Cluster.


[ ] Observability: Integrate Prometheus and Grafana for full-stack monitoring and alerting.


[ ] Secret Management: Implement HashiCorp Vault to Management Cluster for secure injection of credentials and certificates.


[ ] Automated Scaling: Explore Cluster Autoscaler integration for bare-metal providers. 