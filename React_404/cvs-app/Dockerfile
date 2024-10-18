FROM node:20-alpine

WORKDIR /React404

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

RUN npm config set proxy http://team1spring:8080

CMD ["npm", "start"]

ENV CHOKIDAR_USEPOLLING=true
