# Stage 1: Build the Angular application
# Etapa 1: Construcción
FROM node:22-alpine AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build:ssr


# Etapa 2: Servidor de producción
FROM nginx:stable AS final
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist/dockertest .

ENTRYPOINT ["nginx", "-g", "daemon off;"]

#Build: docker build -t test-docker .
#Run: docker run -d -p 8080:80 test-docker
