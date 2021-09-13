#!/bin/sh

./scripts/prepare-bastion.sh

terraform -install-autocomplete
terraform init
terraform apply -auto-approve

alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

while [[ -z `oc1 get no -l beta.kubernetes.io/os=linux 2>/dev/null` ]];do echo 'Waiting worker nodes are ready for Primary Cluster';sleep 5;done
oc1 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
oc1 apply -f ansible/files/cluster-admin.yaml

while [[ -z `oc2 get no -l beta.kubernetes.io/os=linux 2>/dev/null` ]];do echo 'Waiting worker nodes are ready for Secondary Cluster';sleep 5;done
oc2 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
oc2 apply -f ansible/files/cluster-admin.yaml


secret_name=`oc1 get sa/k8s-admin  -n kube-system -o jsonpath='{.secrets[0].name}'`
server=`oc1 config view --minify -o jsonpath={.clusters[0].cluster.server}`
ca=$(oc1 -n kube-system get secret/$secret_name -o jsonpath='{.data.ca\.crt}')
token=`oc1 -n kube-system describe secret/$secret_name |grep ^token: |awk -F' ' {'print $2'}`
namespace=kube-system

echo "
apiVersion: v1
kind: Config
clusters:
- name: primary-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: primary-cluster
    namespace: ${kube-system}
    user: k8s-admin
current-context: default-context
users:
- name: k8s-admin
  user:
    token: ${token}
" > /tmp/admin-primary.kubeconfig

secret_name=`oc2 get sa/k8s-admin  -n kube-system -o jsonpath='{.secrets[0].name}'`
server=`oc2 config view --minify -o jsonpath={.clusters[0].cluster.server}`
ca=$(oc2 -n kube-system get secret/$secret_name -o jsonpath='{.data.ca\.crt}')
token=`oc2 -n kube-system describe secret/$secret_name |grep ^token: |awk -F' ' {'print $2'}`
namespace=kube-system

echo "
apiVersion: v1
kind: Config
clusters:
- name: secondary-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: secondary-cluster
    namespace: ${kube-system}
    user: k8s-admin
current-context: default-context
users:
- name: k8s-admin
  user:
    token: ${token}
" > /tmp/admin-secondary.kubeconfig

echo '####Primary admin kubeconfig = /tmp/admin-primary.kubeconfig ####'
echo '####Secondary admin kubeconfig = /tmp/admin-primary.kubeconfig ####'
./scripts/setup-pwx-cluster.sh
./scripts/setup-app-mysql.sh
./scripts/setup-pwx-backup.sh
