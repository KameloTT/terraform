#!/bin/sh
project='pwx-backup'
region='us-east-1'

eksctl utils associate-iam-oidc-provider --region=$region --cluster=primary-cluster --approve
helm repo add portworx http://charts.portworx.io/ && helm repo update

eksctl utils associate-iam-oidc-provider --region=$region --cluster=secondary-cluster --approve
helm repo add portworx http://charts.portworx.io/ && helm repo update

helm --kubeconfig kubeconfig_primary-cluster install px-central portworx/px-central --namespace $project --create-namespace --version 2.0.1 --set persistentStorage.enabled=true,persistentStorage.storageClassName="gp2",pxbackup.enabled=true

helm --kubeconfig kubeconfig_secondary-cluster install px-central portworx/px-central --namespace $project --create-namespace --version 2.0.1 --set persistentStorage.enabled=true,persistentStorage.storageClassName="gp2",pxbackup.enabled=true

eksctl create iamserviceaccount --name px-backup-account --namespace $project --cluster primary-cluster --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --override-existing-serviceaccounts

eksctl create iamserviceaccount --name px-backup-account --namespace $project --cluster secondary-cluster --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --override-existing-serviceaccounts

#install stork
#curl -fsL -o /tmp/stork-spec.yaml "https://install.portworx.com/2.6?comp=stork&storkNonPx=true"
#oc1 apply -f /tmp/stork-spec.yaml
#oc2 apply -f /tmp/stork-spec.yaml
#rm -rf /tmp/stork-spec.yaml

alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

elb1=`oc1 -n pwx-backup get svc/px-backup-ui -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`
elb2=`oc2 -n pwx-backup get svc/px-backup-ui -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`

echo "Web UI for Primary cluster is $elb1"
echo "Web UI for Secondary cluster is $elb2"
