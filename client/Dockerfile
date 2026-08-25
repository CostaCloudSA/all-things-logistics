# Multi-stage Dockerfile for Flutter Web Client on Google Cloud Run
# Stage 1: Build the Flutter Web application
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec and fetch dependencies
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

# Copy client source code
COPY . .

ARG BACKEND_API_URL=https://logistics-backend-api-979851188322.us-central1.run.app
RUN flutter build web --release --pwa-strategy=none --no-tree-shake-icons --dart-define=BACKEND_API_URL=${BACKEND_API_URL}

# Stage 2: Serve the compiled web bundle via lightweight NGINX
FROM nginx:alpine

# Copy custom NGINX configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build artifacts from builder stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 8080 for Google Cloud Run
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
