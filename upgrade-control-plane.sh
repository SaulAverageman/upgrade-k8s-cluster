#!/bin/bash

export NEW_K8S_VER=1.25.4

echo "upgrading kubeadm"
sudo apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm={NEW-K8S-VER}-00 && \
sudo apt-mark hold kubeadm && \
sudo kubeadm upgrade apply v${NEW-K8S-VER} && \

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
 