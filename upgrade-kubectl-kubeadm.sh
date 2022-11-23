#!/bin/bash

echo "upgrading kubectl and kubelet"
sudo apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet={NEW_K8S_VER}-00 kubectl={NEW_K8S_VER}-00 && \
sudo apt-mark hold kubelet kubectl && \
sudo systemctl daemon-reload && \
sudo systemctl restart kubelet && \
sudo kubeadm upgrade node --ignore-preflight-errors=all