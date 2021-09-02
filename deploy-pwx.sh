#!/bin/bash

./scripts/prepare-bastion.sh
exec bash
terraform init
terraform apply -auto-approve

while [[ -z `oc1 get no -l beta.kubernetes.io/os=linux 2>/dev/null` ]];do echo 'Waiting worker nodes are ready for Primary Cluster';sleep 5;done
oc1 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
oc1 apply -f ansible/files/cluster-admin.yaml

while [[ -z `oc2 get no -l beta.kubernetes.io/os=linux 2>/dev/null` ]];do echo 'Waiting worker nodes are ready for Secondary Cluster';sleep 5;done
oc2 label node -l beta.kubernetes.io/os=linux  node-role.kubernetes.io/worker=
oc2 apply -f ansible/files/cluster-admin.yaml

#./scripts/deploy_app1.sh
./scripts/setup-pwx-cluster.sh
./scripts/setup-pwx-backup.sh
