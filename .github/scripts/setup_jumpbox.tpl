#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl lsb-release gnupg-agent software-properties-common mysql-client
curl -fsSL https://get.docker.com -o get-docker.sh && sudo chmod +x get-docker.sh && ./get-docker.sh
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update -y
sudo apt-get install azure-cli -y
sudo az aks install-cli
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
git clone https://github.com/diamadiskon/dk_fast_react_propel.git
# az login --identity
# az aks get-credentials --resource-group 'rg-fast-react-dev-weu' --name 'aks-fast-react-dev-weu' --overwrite-existing
# sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
# az acr login --name acrfastreactdevweuh2ww2
# sudo docker-compose build
# sudo docker tag fullstack-react-fastapi-propel-backend acrfastreactdevweuh2ww2.azurecr.io/app/backend
# sudo docker tag fullstack-react-fastapi-propel-frontend acrfastreactdevweuh2ww2.azurecr.io/app/frontend
# sudo docker push acrfastreactdevweuh2ww2.azurecr.io/app/backend
# sudo docker push acrfastreactdevweuh2ww2.azurecr.io/app/frontend
# az aks update -n 'aks-fast-react-dev-weu' -g 'rg-fast-react-dev-weu' --attach-acr 'acrfastreactdevweuh2ww2'
# kubectl create namespace ingress-basic 
# Add the official stable repository
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo add stable https://kubernetes-charts.storage.googleapis.com/
# helm repo update

# #  Customizing the Chart Before Installing. 
# helm show values ingress-nginx/ingress-nginx

# # Use Helm to deploy an NGINX ingress controller
# helm install ingress-nginx ingress-nginx/ingress-nginx \
#     --namespace ingress-basic \
#     --set controller.replicaCount=2 \
#     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set controller.service.externalTrafficPolicy=Local \
#     --set controller.service.loadBalancerIP="REPLACE_STATIC_IP" 