#!/bin/sh

curl -o /tmp/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
chmod +x /tmp/aws-iam-authenticator
mkdir -p $HOME/bin && mv /tmp/aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

sudo yum install python39 vim -y
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python3 /tmp/get-pip.py --user
python3 -m pip install --user ansible
rm -rf /tmp/get-pip.py

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

wget https://get.helm.sh/helm-canary-linux-amd64.tar.gz -O /tmp/helm.tar.gz
tar -zxvf /tmp/helm.tar.gz -C /tmp/
sudo mv /tmp/linux-amd64/helm /usr/bin/helm
chmod +x /usr/bin/helm

ansible-playbook ansible/aliases.yml
alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'


oc1 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
oc2 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=

exec bash
