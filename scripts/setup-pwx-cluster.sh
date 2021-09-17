#!/bin/sh

key=`cat ~/.aws/credentials |grep ^aws_access_key_id |awk -F'= ' {'print $2'}`
secret=`cat ~/.aws/credentials |grep ^aws_secret_access_key |awk -F'= ' {'print $2'}`
project='kube-system'
alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

oc1 create namespace $project --dry-run=client -o yaml | oc1 apply -f -
oc1 create secret generic --from-file=$HOME/.aws/credentials -n $project aws-creds

oc1 -n $project create secret generic alertmanager-portworx --from-file=ansible/files/alertmanager.yaml --dry-run=client -o yaml | oc1 apply -f -
oc1 -n $project apply -f https://install.portworx.com/2.8?comp=pxoperator
sleep 5
while [ `oc1 get crd -o name | grep storageclusters.core.libopenstorage.org`1 != 'customresourcedefinition.apiextensions.k8s.io/storageclusters.core.libopenstorage.org1' ]
do
	echo "Waiting Operator Applying"
done

oc1 -n $project apply -f "https://install.portworx.com/2.8?operator=true&mc=false&kbver=1.20.7-eks-d88609&b=true&kd=type%3Dgp2%2Csize%3D150&csicd=true&s=%22type%3Dgp2%2Csize%3D150%22&j=auto&c=px-primary-e08f7201-b224-4a5f-b9a5-b61cba23297f&eks=true&stork=true&csi=true&mon=true&st=k8s&e=AWS_ACCESS_KEY_ID%3D${key}%2CAWS_SECRET_ACCESS_KEY%3D${secret}&promop=true"
oc1 apply -f ansible/files/pwx-svc-ext.yaml

while [ `oc1 get storageclusters.core.libopenstorage.org/px-primary-e08f7201-b224-4a5f-b9a5-b61cba23297f -n kube-system 2>/dev/null -o name`1 != 'storagecluster.core.libopenstorage.org/px-primary-e08f7201-b224-4a5f-b9a5-b61cba23297f'1 ]
do 
  echo "Waiting StorageCluster Object"
done
oc1 patch -n kube-system --type merge storageclusters.core.libopenstorage.org/px-primary-e08f7201-b224-4a5f-b9a5-b61cba23297f -p '{"spec":{"stork":{"volumes":[{"mountPath":"/root/.aws/","name":"aws-creds","secret":{"secretName":"aws-creds"}}]}}}'

oc2 create namespace $project --dry-run=client -o yaml | oc2 apply -f -
oc2 -n $project create secret generic alertmanager-portworx --from-file=ansible/files/alertmanager.yaml --dry-run=client -o yaml | oc2 apply -f -
oc2 -n $project apply -f https://install.portworx.com/2.8?comp=pxoperator
while [ `oc2 get crd -o name | grep storageclusters.core.libopenstorage.org`1 != 'customresourcedefinition.apiextensions.k8s.io/storageclusters.core.libopenstorage.org1' ]
do
        echo "Waiting Operator Applying"
done
oc2 -n $project apply -f "https://install.portworx.com/2.8?operator=true&mc=false&kbver=1.20.7-eks-d88609&b=true&kd=type%3Dgp2%2Csize%3D150&csicd=true&s=%22type%3Dgp2%2Csize%3D150%22&j=auto&c=px-secondary-e08f7201-b224-4a5f-b9a5-b61cba23297f&eks=true&stork=true&csi=true&mon=true&st=k8s&e=AWS_ACCESS_KEY_ID%3D${key}%2CAWS_SECRET_ACCESS_KEY%3D${secret}&promop=true"
oc2 apply -f ansible/files/pwx-svc-ext.yaml


elb1=`oc1 -n kube-system get svc/portworx-service-ext -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`
elb2=`oc2 -n kube-system get svc/portworx-service-ext -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`

echo "External API for Primary cluster is $elb1"
echo "External API for Secondary cluster is $elb2"
