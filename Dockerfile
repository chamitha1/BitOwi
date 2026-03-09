FROM ghcr.io/cirruslabs/flutter:3.38.5 AS build

WORKDIR /app

# Copy dependency files first (better caching)
COPY pubspec.* ./
RUN flutter pub get

# Copy full project
COPY . .

# Enable web
RUN flutter config --enable-web

# Build web in release mode
RUN flutter build web --release

FROM nginx:stable-alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built web files
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]