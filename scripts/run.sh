#!/bin/bash
#
cd ~/ansible
ansible-playbook install-gitlab.yaml
ansible-playbook configure-gitaly.yaml
ansible-playbook configure-gitaly.yaml
