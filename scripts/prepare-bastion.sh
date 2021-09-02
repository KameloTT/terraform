#!/bin/bash

curl -o /tmp/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
chmod +x /tmp/aws-iam-authenticator
mkdir -p $HOME/bin && cp /tmp/aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

sudo yum install python39 vim -y
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python3 /tmp/get-pip.py --user
python3 -m pip install --user ansible

rm -rf /tmp/get-pip.py /tmp/aws-iam-authenticator

ansible-playbook ansible/aliases.yml
exec bash

oc1 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
oc2 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
