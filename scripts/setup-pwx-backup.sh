eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=primary-cluster --approve
helm repo add portworx http://charts.portworx.io/ && helm repo update

eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=secondary-cluster --approve
helm repo add portworx http://charts.portworx.io/ && helm repo update

helm --kubeconfig kubeconfig_primary-cluster install px-central portworx/px-central --namespace pwx --create-namespace --version 2.0.1 --set persistentStorage.enabled=true,persistentStorage.storageClassName="gp2",pxbackup.enabled=true

helm --kubeconfig kubeconfig_secondary-cluster install px-central portworx/px-central --namespace pwx --create-namespace --version 2.0.1 --set persistentStorage.enabled=true,persistentStorage.storageClassName="gp2",pxbackup.enabled=true

eksctl create iamserviceaccount --name px-backup-account --namespace pwx --cluster primary-cluster --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --override-existing-serviceaccounts

eksctl create iamserviceaccount --name px-backup-account --namespace pwx --cluster secondary-cluster --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --override-existing-serviceaccounts

#install stork
#curl -fsL -o /tmp/stork-spec.yaml "https://install.portworx.com/2.6?comp=stork&storkNonPx=true"
#oc1 apply -f /tmp/stork-spec.yaml
#oc2 apply -f /tmp/stork-spec.yaml
#rm -rf /tmp/stork-spec.yaml

