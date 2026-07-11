# Build Stage
FROM node:16.20.2-buster-slim AS build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

# Accept API URL from Jenkins
ARG API_URL
ENV API_URL=${API_URL}

# Build React application
RUN npm run build

# Runtime Stage
FROM nginx:alpine

COPY --from=build /usr/src/app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]




