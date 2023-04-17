FROM node:19.9.0 as build 

WORKDIR /app

COPY package*.json .
RUN npm install --production

COPY . .
RUN npm run build

FROM nginx:1.24.0
ENV NODE_ENV=production

COPY ./containers/nginx.conf /etc/nginx/nginx.conf

COPY --from=build /app/build /usr/share/nginx/html