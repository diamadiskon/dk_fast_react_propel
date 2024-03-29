#!/bin/bash
az login --identity
az aks get-credentials --resource-group 'rg-fast-react-dev-weu' --name 'aks-fast-react-dev-weu' --overwrite-existing
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
az acr login --name acrfastreactdevweuh2ww2
git clone https://github.com/diamadiskon/dk_fast_react_propel.git
cd dk_fast_react_propel || exit
sudo chmod +x docker-compose
sudo docker-compose build
sudo docker tag fullstack-react-fastapi-propel-backend acrfastreactdevweuh2ww2.azurecr.io/app/backend
sudo docker tag fullstack-react-fastapi-propel-frontend acrfastreactdevweuh2ww2.azurecr.io/app/frontend
sudo docker push acrfastreactdevweuh2ww2.azurecr.io/app/backend
sudo docker push acrfastreactdevweuh2ww2.azurecr.io/app/frontend
az aks update -n 'aks-fast-react-dev-weu' -g 'rg-fast-react-dev-weu' --attach-acr 'acrfastreactdevweuh2ww2'
kubectl create namespace ingress-basic
alias k=kubectl
kubectl create namespace app

# Pass the variable for ingress controller
static_ip=$(az network public-ip show --resource-group rg-fast-react-dev-weu --name pip-cdf-fast-react-we --query "ipAddress" --output tsv)

# Create ingressing controller
az aks approuting enable -g rg-fast-react-dev-weu -n aks-fast-react-dev-weu


# # Enable the Application Gateway addon on the AKS cluster(they should move to bicep)
# appgwId=$(az network application-gateway show -n agw-fast-react-we -g rg-fast-react-dev-weu -o tsv --query "id")
# az aks enable-addons -n aks-fast-react-dev-weu -g rg-fast-react-dev-weu -a ingress-appgw --appgw-id "$appgwId"

# Add the official stable repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
#  Customizing the Chart Before Installing. 
helm show values ingress-nginx/ingress-nginx
# Use Helm to deploy an NGINX ingress controller
# helm install ingress-nginx ingress-nginx/ingress-nginx \
#     --namespace ingress-basic \
#     --set controller.replicaCount=2 \
#     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
#     --set controller.service.externalTrafficPolicy=Local \
#     --set controller.service.loadBalancerIP="$static_ip"
