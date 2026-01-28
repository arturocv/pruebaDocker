# Stage 1: Build the Angular application
# Etapa 1: Construcción
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
RUN npm install -g @angular/cli
COPY . .
RUN npm run build --configuration=production

# Etapa 2: Servidor de producción
FROM nginx:stable AS final
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist/dockertest/browser /usr/share/nginx/html

EXPOSE 80

#CMD ["nginx", "-g", "daemon off;"]

#Build: docker build -t test-docker .
#Run: docker run -d -p 8080:80 test-docker
