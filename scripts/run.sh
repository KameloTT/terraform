#!/bin/bash
#
cd ~/ansible
ansible-playbook install-gitlab.yaml
ansible-playbook configure-gitaly.yaml
ansible-playbook configure-praefect.yaml
ansible-playbook configure-monitoring.yaml
ansible-playbook configure-application.yaml
