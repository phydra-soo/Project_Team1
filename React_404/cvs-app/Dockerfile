FROM node:20-alpine AS build

WORKDIR /app

COPY package.json ./

RUN npm install

COPY webpackDevServer.config.js ./node_modules/react-scripts/config/

RUN ls -l ./node_modules/react-scripts/config/
RUN cat ./node_modules/react-scripts/config/webpackDevServer.config.js

COPY . .

FROM node:20-alpine

WORKDIR /app

COPY --from=build /app /app

EXPOSE 3000

RUN npm config set proxy http://team1spring:8080

CMD ["npm", "start"]

ENV CHOKIDAR_USEPOLLING=true
