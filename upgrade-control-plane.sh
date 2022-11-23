#!/bin/bash

export NEW_K8S_VER=1.25.3

echo "upgrading kubeadm"
sudo apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=${NEW_K8S_VER}-00 && \
sudo apt-mark hold kubeadm && \
sudo kubeadm upgrade apply v${NEW_K8S_VER} --ignore-preflight-errors=all && \

sh upgrade-kubectl-kubeadm.sh && \

#upgrade nodes
for node in $(kubectl get nodes -o name)
do
	node=${node##*/}
	if(( ${node}=="vm-master" ))
	then
		continue
	fi
	kubectl cordon ${node} && \
	kubectl drain ${node} --ignore-daemonsets && \
	ssh azureuser@${node} 'bash -s' < upgrade-kubectl-kubeadm.sh && \
	kubectl uncordon ${node}
done
 