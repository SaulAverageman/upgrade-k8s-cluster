#!/bin/bash
echo "upgrading kubeadm"
apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.24.6-00 && \
apt-mark hold kubeadm
sudo kubeadm upgrade apply v1.24.6

sh upgrade-kubectl-kubeadm.sh

#upgrade nodes
for node in $(kubectl get nodes -o name)
do
	kubectl cordon ${node}
	kubectl drain ${node} --ignore-daemonsets
	ssh azureuser@${node} 'bash -s' < upgrade-kubectl-kubeadm.sh
	kubectl uncordon ${node}
done
 