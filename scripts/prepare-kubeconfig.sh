#!/bin/bash
# Забираем свежий конфиг прямо с первого мастера
# MASTER_IP — это переменная, которую можно задать в GitLab или взять из инвентори
scp -o StrictHostKeyChecking=no root@${MASTER_IP}:/etc/kubernetes/admin.conf ~/.kube/config

# Исправляем адрес сервера в конфиге (если внутри admin.conf указан localhost или внутренний IP)
# Мы заменяем его на наш внешний VIP, чтобы раннер мог достучаться
sed -i "s|server: https://.*:6443|server: https://${CLUSTER_VIP}:6443|g" ~/.kube/config

chmod 600 ~/.kube/config