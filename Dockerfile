# syntax=docker/dockerfile:1

# ---------- Build de Flutter web ----------
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app

# pubspec.lock está en .gitignore, así que no existe en el build context.
COPY pubspec.yaml ./
RUN flutter pub get

COPY . .

# La URL del backend se inyecta en build (Dokploy: Advanced → Build Arguments).
ARG API_BASE_URL=http://localhost:8000/api/v1
RUN flutter build web --release --dart-define=API_BASE_URL=${API_BASE_URL}

# ---------- Servidor estático ----------
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
