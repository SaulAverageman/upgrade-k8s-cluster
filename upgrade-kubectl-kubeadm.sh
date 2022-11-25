#!/bin/bash

export NEW_K8S_VER=1.25.3

echo "upgrading kubeadm"
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=${NEW_K8S_VER}-00 && \
sudo kubeadm upgrade apply v${NEW_K8S_VER} --ignore-preflight-errors=all && \

echo "Saul says-upgrading kubectl and kubelet"
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=${NEW_K8S_VER}-00 kubectl=${NEW_K8S_VER}-00 && \
sudo systemctl daemon-reload && \
sudo systemctl restart kubelet
