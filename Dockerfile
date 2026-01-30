# ---------- BUILD ----------
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# ---------- SERVE ----------
FROM nginx:alpine

# Limpiar contenido por defecto
RUN rm -rf /usr/share/nginx/html/*

# Copiar el build real de Angular (nivel browser)
# IMPORTANTE: la barra final es clave
COPY --from=build /app/dist/angulartest/browser/ /usr/share/nginx/html/

# Configuración Nginx SPA
RUN rm /etc/nginx/conf.d/default.conf
RUN echo 'server { \
  listen 80; \
  server_name _; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { \
  try_files $uri $uri/ /index.html; \
  } \
  }' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
