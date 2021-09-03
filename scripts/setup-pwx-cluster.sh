#!/bin/sh

key=`cat ~/.aws/credentials |grep ^aws_access_key_id |awk -F'= ' {'print $2'}`
secret=`cat ~/.aws/credentials |grep ^aws_secret_access_key |awk -F'= ' {'print $2'}`
project='kube-system'
alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

oc1 create namespace $project --dry-run=client -o yaml | oc1 apply -f -
oc1 -n $project create secret generic alertmanager-portworx --from-file=ansible/files/alertmanager.yaml --dry-run=client -o yaml | oc1 apply -f -
oc1 -n $project apply -f https://install.portworx.com/2.8?comp=pxoperator
sleep 5
oc1 -n $project apply -f "https://install.portworx.com/2.8?operator=true&mc=false&kbver=1.20.7-eks-d88609&b=true&kd=type%3Dgp2%2Csize%3D150&csicd=true&s=%22type%3Dgp2%2Csize%3D150%22&j=auto&c=px-primary-e08f7201-b224-4a5f-b9a5-b61cba23297f&eks=true&stork=true&csi=true&mon=true&st=k8s&e=AWS_ACCESS_KEY_ID%3D${key}%2CAWS_SECRET_ACCESS_KEY%3D${secret}&promop=true"
#oc1 -n $project apply -f ansible/files/lb-svc.yaml


oc2 create namespace $project --dry-run=client -o yaml | oc2 apply -f -
oc2 -n $project create secret generic alertmanager-portworx --from-file=ansible/files/alertmanager.yaml --dry-run=client -o yaml | oc2 apply -f -
oc2 -n $project apply -f https://install.portworx.com/2.8?comp=pxoperator
sleep 5
oc2 -n $project apply -f "https://install.portworx.com/2.8?operator=true&mc=false&kbver=1.20.7-eks-d88609&b=true&kd=type%3Dgp2%2Csize%3D150&csicd=true&s=%22type%3Dgp2%2Csize%3D150%22&j=auto&c=px-secondary-e08f7201-b224-4a5f-b9a5-b61cba23297f&eks=true&stork=true&csi=true&mon=true&st=k8s&e=AWS_ACCESS_KEY_ID%3D${key}%2CAWS_SECRET_ACCESS_KEY%3D${secret}&promop=true"
#oc2 -n $project apply -f ansible/files/lb-svc.yaml
