#!/bin/bash

export NEW_K8S_VER=1.25.3

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
 