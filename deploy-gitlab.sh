#!/bin/bash

#scp -i gitlab gitlab centos@`terraform output -raw bastion-public-dns`:~/
scp -r -i gitlab ~/.aws gitlab scripts ansible centos@`terraform output -raw bastion-public-dns`:~/
ssh -i gitlab centos@`terraform output -raw bastion-public-dns` bash -c '~/scripts/prepare-bastion.sh'
ssh -i gitlab centos@`terraform output -raw bastion-public-dns` bash -c '~/scripts/run.sh'
