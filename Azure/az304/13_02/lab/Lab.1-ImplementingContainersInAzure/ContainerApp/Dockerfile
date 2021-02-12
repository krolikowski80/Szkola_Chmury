FROM node:carbon
WORKDIR /usr/src/app
COPY package*.json ./
COPY index.js ./
RUN npm install
EXPOSE 3000
ENTRYPOINT [ "npm","start" ]