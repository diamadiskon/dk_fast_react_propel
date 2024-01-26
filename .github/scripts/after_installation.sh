#!/bin/bash
az login --identity
az aks get-credentials --resource-group 'rg-fast-react-dev-weu' --name 'aks-fast-react-dev-weu' --overwrite-existing
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
az acr login --name acrfastreactdevweuh2ww2
git clone https://github.com/diamadiskon/dk_fast_react_propel.git
sudo ./dk_fast_react_propel/docker-compose build
sudo docker tag fullstack-react-fastapi-propel-backend acrfastreactdevweuh2ww2.azurecr.io/app/backend
sudo docker tag fullstack-react-fastapi-propel-frontend acrfastreactdevweuh2ww2.azurecr.io/app/frontend
sudo docker push acrfastreactdevweuh2ww2.azurecr.io/app/backend
sudo docker push acrfastreactdevweuh2ww2.azurecr.io/app/frontend
az aks update -n 'aks-fast-react-dev-weu' -g 'rg-fast-react-dev-weu' --attach-acr 'acrfastreactdevweuh2ww2'
