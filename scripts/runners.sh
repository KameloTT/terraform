#!/bin/bash
aws eks update-kubeconfig --name gitlab-eks
sudo wget https://get.helm.sh/helm-canary-linux-amd64.tar.gz -O /tmp/helm.tar.gz
sudo tar -zxvf /tmp/helm.tar.gz -C /tmp/
sudo mv /tmp/linux-amd64/helm /usr/bin/helm
sudo chmod +x /usr/bin/helm
helm repo add gitlab https://charts.gitlab.io

cat > /tmp/values.yaml << EOF
gitlabUrl: http://`terraform output -raw gitlab-gui`
runnerRegistrationToken: ""
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        image = "ubuntu:16.04"
EOF

helm install --namespace default gitlab-runner -f /tmp/values.yaml gitlab/gitlab-runner
