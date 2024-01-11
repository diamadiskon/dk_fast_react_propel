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
# sudo az login --identity
# sudo az aks get-credentials --resource-group 'rg-fast-react-dev-weu' --name 'aks-fast-react-dev-weu' --overwrite-existing
# sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
# sudo az acr login --name acrfastreactdevweuh2ww2
# sudo docker-compose build
# sudo docker tag fullstack-react-fastapi-propel-backend acrfastreactd2.azurecr.io/app/backend
# sudo docker tag fullstack-react-fastapi-propel-frontend acrfastreactd2.azurecr.io/app/frontend
# sudo docker push acrfastreactd2.azurecr.io/app/backend
# sudo docker push acrfastreactd2.azurecr.io/app/frontend
# sudo az aks update -n 'aks-fast-react-dev-weu' -g 'rg-fast-react-dev-weu' --attach-acr 'acrfastreactdevweuh2ww2'
