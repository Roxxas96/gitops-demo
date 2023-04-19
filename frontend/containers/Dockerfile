FROM node:19.9.0 

WORKDIR /app

COPY package*.json .
RUN npm install --production

COPY . .
RUN npm run build

ENV NODE_ENV=production
ENV PORT=80
CMD ["npm", "start"]