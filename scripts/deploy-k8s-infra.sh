#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

KUBECONFIG_PATH="${HOME}/.kube/config"

if [ ! -f "$KUBECONFIG_PATH" ]; then
    echo -e "❌ Файл конфига не найден по пути $KUBECONFIG_PATH"
    exit 1
fi

export KUBECONFIG="$KUBECONFIG_PATH"

echo -e "${BLUE}=== Проверка связи с кластером ===${NC}"
kubectl cluster-info

echo -e "\n${BLUE}=== Обновление Helm репозиториев ===${NC}"
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo add metallb https://metallb.github.io/metallb
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo -e "\n${BLUE}=== Установка Calico (Tigera Operator) ===${NC}"

helm upgrade --install calico projectcalico/tigera-operator \
    --namespace tigera-operator \
    --create-namespace \
    --set installation.calicoNetwork.ipPools[0].cidr="10.244.0.0/16" \
    --set installation.calicoNetwork.ipPools[0].encapsulation=VXLAN \
    --set installation.calicoNetwork.nodeAddressAutodetectionV1.interface=ens4


echo -e "\n${BLUE}=== Установка MetalLB ===${NC}"
helm upgrade --install metallb metallb/metallb \
    --namespace metallb-system \
    --create-namespace

echo -e "\n${BLUE}=== Установка Ingress Nginx ===${NC}"
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace \
    --set controller.service.type=LoadBalancer

echo -e "\n${GREEN}✅ Базовая инфраструктура отправлена в кластер!${NC}"
echo "Используй 'kubectl get pods -A' чтобы следить за процессом запуска."