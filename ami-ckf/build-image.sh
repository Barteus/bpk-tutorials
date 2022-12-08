#!/bin/bash

echo "127.0.0.1   demo-nano" | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname demo-nano
sudo reboot

sudo snap install juju --classic
sudo snap install microk8s --classic --channel=1.24/stable
sudo snap install kubectl --classic

mkdir -p ~/.kube
sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube
newgrp microk8s

microk8s enable dns storage ingress metallb:10.64.140.43-10.64.140.49

microk8s config | sed 's/172.31.14.228/127.0.0.1/g' > ~/.kube/config

juju bootstrap microk8s
juju add-model kubeflow

sed -i 's/172.31.14.228/127.0.0.1/g' ~/.local/share/juju/bootstrap-config.yaml
sed -i 's/172.31.14.228/127.0.0.1/g' ~/.local/share/juju/controllers.yaml

juju deploy kubeflow --trust

juju config dex-auth public-url=http://10.64.140.43.nip.io
juju config oidc-gatekeeper public-url=http://10.64.140.43.nip.io
juju config dex-auth static-username=admin
juju config dex-auth static-password=admin
juju config minio access-key=minio123 secret-key=minio123

microk8s stop

#on new instance startup
sudo hostnamectl set-hostname demo-nano
sudo reboot
microk8s start

