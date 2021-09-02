#!/bin/bash
key=`cat ~/.aws/credentials |grep ^aws_access_key_id |awk -F'= ' {'print $2'}`
secret=`cat ~/.aws/credentials |grep ^aws_secret_access_key |awk -F'= ' {'print $2'}`
oc1 create secret generic alertmanager-portworx --from-file=scripts/alertmanager.yaml -n kube-system
oc1 create -f https://docs.portworx.com/samples/k8s/grafana/prometheus-operator.yaml
oc1 create -f https://docs.portworx.com/samples/k8s/portworx-pxc-operator.yaml
oc1 -n kube-system create secret generic alertmanager-portworx --from-file=ansible/files/alertmanager.yaml
oc1  apply -f "https://install.portworx.com/2.8?mc=false&kbver=1.20.7-eks-d88609&b=true&f=true&j=auto&kd=type%3Dgp2%2Csize%3D150&c=px-cluster-5aae464d-ad51-4e0a-aa75-939f0f2f2f9d&eks=true&stork=true&csi=true&mon=true&st=k8s&e=AWS_ACCESS_KEY_ID%3D${key}%2CAWS_SECRET_ACCESS_KEY%3D${secret}"

#oc1 -n kube-system apply -f ansible/files/lb-svc.yaml
oc2 create secret generic alertmanager-portworx --from-file=scripts/alertmanager.yaml -n kube-system
oc2 create -f https://docs.portworx.com/samples/k8s/grafana/prometheus-operator.yaml
oc2 apply -f https://docs.portworx.com/samples/k8s/portworx-pxc-operator.yaml
oc2 -n kube-system create secret generic alertmanager-portworx --from-file=ansible/files/alertmanager.yaml
oc2  apply -f "https://install.portworx.com/2.8?mc=false&kbver=1.20.7-eks-d88609&b=true&f=true&j=auto&kd=type%3Dgp2%2Csize%3D150&c=px-secondary-e08f7201-b224-4a5f-b9a5-b61cba23297f&eks=true&stork=true&csi=true&mon=true&st=k8s&e=AWS_ACCESS_KEY_ID%3D${key}%2CAWS_SECRET_ACCESS_KEY%3D${secret}"

#oc2 -n kube-system apply -f ansible/files/lb-svc.yaml
