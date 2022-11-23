#!/bin/bash

echo "upgrading kubeadm"
sudo apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=${NEW_K8S_VER}-00 && \
sudo kubeadm upgrade apply v${NEW_K8S_VER} --ignore-preflight-errors=all && \

echo "Bubai says-upgrading kubectl and kubelet"
sudo apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=${NEW_K8S_VER}-00 kubectl=${NEW_K8S_VER}-00 && \
sudo kubeadm upgrade node --ignore-preflight-errors=all && \
sudo systemctl daemon-reload && \
sudo systemctl restart kubelet