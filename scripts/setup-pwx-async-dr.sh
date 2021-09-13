#!/bin/sh

alias oc1='kubectl --kubeconfig=kubeconfig_primary-cluster'
alias oc2='kubectl --kubeconfig=kubeconfig_secondary-cluster'

STORK_POD=$(oc1 get pods -n kube-system -l name=stork -o jsonpath='{.items[0].metadata.name}') &&
oc1 cp -n kube-system $STORK_POD:/storkctl/linux/storkctl ./storkctl
sudo mv storkctl /usr/local/bin &&
sudo chmod +x /usr/local/bin/storkctl
