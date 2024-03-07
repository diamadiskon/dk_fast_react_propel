#!/bin/bash
az login --identity
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo az acr login --name acrfastreactdevneuotldn
git clone https://github.com/diamadiskon/dk_fast_react_propel.git
cd dk_fast_react_propel || exit
sudo chmod +x docker-compose.yml
sudo docker-compose build
sudo docker tag fullstack-react-fastapi-propel-backend acrfastreactdevneuotldn.azurecr.io/app/backend
sudo docker tag fullstack-react-fastapi-propel-frontend acrfastreactdevneuotldn.azurecr.io/app/frontend
sudo docker push acrfastreactdevneuotldn.azurecr.io/app/backend
sudo docker push acrfastreactdevneuotldn.azurecr.io/app/frontend
