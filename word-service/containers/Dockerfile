FROM node:19.9.0 as build 

WORKDIR /app

COPY package*.json .
RUN npm install --production

COPY . .
RUN npm run build

ENV NODE_ENV=production
ENV PORT=80
CMD ["node", "dist/main.js"]