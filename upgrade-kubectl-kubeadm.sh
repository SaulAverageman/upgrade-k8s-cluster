#!/bin/bash

NEW-K8S-VER=1.25.4

echo "upgrading kubectl and kubelet"
apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet={NEW-K8S-VER}-00 kubectl={NEW-K8S-VER}-00 && \
apt-mark hold kubelet kubectl && \
sudo systemctl daemon-reload && \
sudo systemctl restart kubelet && \
sudo kubeadm upgrade node