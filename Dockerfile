# ---------- BUILD ----------
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# ---------- NGINX ----------
FROM nginx:alpine

# borrar config por defecto
RUN rm /etc/nginx/conf.d/default.conf

# copiar nuestra config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# copiar el build REAL de angular
COPY --from=build /app/dist/angulartest/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
