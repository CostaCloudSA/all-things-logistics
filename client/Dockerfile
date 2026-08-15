# Multi-stage Dockerfile for Flutter Web Deployment on Google Cloud Run
# Stage 1: Build the Flutter Web Application
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY pubspec.yaml .
RUN flutter pub get

COPY . .
RUN flutter build web --release

# Stage 2: Production NGINX Server on Cloud Run
FROM nginx:alpine

# Copy compiled Flutter web assets to NGINX root
COPY --from=build /app/build/web /usr/share/nginx/html

# Custom NGINX configuration for Cloud Run (port 8080) and SPA routing
RUN echo 'server { \
    listen 8080; \
    server_name localhost; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
