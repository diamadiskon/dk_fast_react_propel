FROM node:16.4.0-buster
# RUN mkdir -p /home/node/src
WORKDIR /src

ADD package.json /src

RUN npm install

ADD . /src

COPY . .

EXPOSE 3000

EXPOSE 443


CMD [ "npm", "run" ]