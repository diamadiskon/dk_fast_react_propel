FROM node:16.4.0-buster
# RUN mkdir -p /home/node/src
WORKDIR /app
COPY ./package.json ./

RUN npm install

COPY . ./

EXPOSE 3000

CMD [ "npm", "start" ]