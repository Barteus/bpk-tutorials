sudo snap remove microk8s --purge
sudo snap install microk8s  --classic

microk8s enable ingress metallb:10.64.140.43-10.64.140.49

alias kubectl="microk8s kubectl"

microk8s kubectl get po -n ingress

microk8s kubectl apply -f ./ingress-service.yaml

microk8s kubectl create ns test
microk8s kubectl create deployment demo --image=httpd --port=80 -n test
microk8s kubectl expose deployment demo -n test

microk8s kubectl apply -f ./ingress-rule.yaml
