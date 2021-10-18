#!/bin/sh

region=`cat ~/.aws/credentials |grep ^region |awk -F'= ' {'print $2'}`
key=`cat ~/.aws/credentials |grep ^aws_access_key_id |awk -F'= ' {'print $2'}`
secret=`cat ~/.aws/credentials |grep ^aws_secret_access_key |awk -F'= ' {'print $2'}`
alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

echo "Setup Stork"
STORK_POD=$(oc1 get pods -n kube-system -l name=stork -o jsonpath='{.items[0].metadata.name}') &&
oc1 cp -n kube-system $STORK_POD:/storkctl/linux/storkctl ./storkctl
sudo mv storkctl /usr/local/bin &&
sudo chmod +x /usr/local/bin/storkctl


echo "Secondary CLuster. Create Credentials"
pod=`oc2 get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}'`
uuid=`oc2 exec $pod -n kube-system -- /opt/pwx/bin/pxctl status 2>/dev/null | grep UUID | awk '{print $3}'`
oc2 exec $pod -n kube-system -- /opt/pwx/bin/pxctl license activate 5c73-e11f-242a-47a7-ad50-e283-dd17-b22b
oc2 exec $pod -n kube-system -- /opt/pwx/bin/pxctl credentials create --provider s3 --s3-access-key $key --s3-secret-key $secret --s3-region $region  --s3-endpoint s3.amazonaws.com --s3-storage-class STANDARD clusterPair_$uuid

echo "Primary CLuster. Create Credentials"
pod=`oc1 get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}'`
oc1 exec $pod -n kube-system -- /opt/pwx/bin/pxctl license activate 5c73-e11f-242a-47a7-ad50-e283-dd17-b22b
oc1 exec $pod -n kube-system -- /opt/pwx/bin/pxctl credentials create --provider s3 --s3-access-key $key --s3-secret-key $secret --s3-region $region  --s3-endpoint s3.amazonaws.com --s3-storage-class STANDARD clusterPair_$uuid

ansible-playbook ansible/cluster-pair-mysql.yaml
ansible-playbook ansible/cluster-pair-mysql-failback.yaml

oc1 apply -f /tmp/cluster_pair_mysql.yaml
oc2 apply -f /tmp/cluster_pair_mysql_failback.yaml

oc1 apply -f ansible/files/migrationpolicy_mysql.yaml

oc1 apply -f ansible/files/migration_schedule_mysql.yaml
