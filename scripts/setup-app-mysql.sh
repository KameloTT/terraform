#!/bin/sh

project='kube-system'
alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

oc1 apply -f ansible/files/app-mysql/

while [[ `oc1 -n pwx-test-app1 get po  -l app=ooo-mysql |grep -v "STATUS" |grep -v "1/1"` ]];do echo 'App DB. Waiting while Database will be up and running';sleep 5;done
echo "App DB. Application Test Database is up and running"
sleep 30
echo "App DB. Status of Mysql cluster"
oc1 -n pwx-test-app1 exec -it mysql-2 -- bash -c "mysql -u root -pglonti --execute=\"SHOW STATUS LIKE 'wsrep%';\" |grep wsrep_local_state_comment" |awk {'print $2'}

echo "App DB. Members of Mysql cluster"
oc1 -n pwx-test-app1 exec -it mysql-2 -- bash -c "mysql -u root -pglonti --execute=\"SHOW STATUS LIKE 'wsrep%';\" |grep wsrep_incoming_addresses" |awk {'print $2'} |sed "s/,/\n/g" |sed "s/^/ - /g"

echo "App DB. Create New database 'testdb'"
oc1 -n pwx-test-app1 exec -it mysql-2 -- bash -c "mysql -u root -pglonti --execute=\"CREATE DATABASE IF NOT EXISTS testdb\""

echo "App DB. Show list of available Databases"
oc1 -n pwx-test-app1 exec -it mysql-2 -- bash -c "mysql -u root -pglonti --execute=\"SHOW DATABASES\""
