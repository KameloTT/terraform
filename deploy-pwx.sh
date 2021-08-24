#!/bin/bash

./scripts/prepare-bastion.sh
exec bash


#scp -i gitlab gitlab centos@`terraform output -raw bastion-public-dns`:~/
#scp -r -i pwx ~/.aws pwx scripts ansible centos@`terraform output -raw bastion-public-dns`:~/
#ssh -i pwx centos@`terraform output -raw bastion-public-dns` bash -c '~/scripts/prepare-bastion.sh'
#ssh -i pwx centos@`terraform output -raw bastion-public-dns` bash -c '~/scripts/run.sh'
