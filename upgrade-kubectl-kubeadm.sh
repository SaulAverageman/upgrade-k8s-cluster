#!/bin/bash

echo "upgrading kubectl and kubelet"
apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.24.6-00 kubectl=1.24.6-00 && \
apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo kubeadm upgrade node