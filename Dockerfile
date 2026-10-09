# syntax=docker/dockerfile:1

# ---------- Build de Flutter web ----------
# Base con las herramientas que necesita la CLI de Flutter.
FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip \
    && rm -rf /var/lib/apt/lists/*

# Flutter estable oficial (Dart 3.13.5). Cirruslabs no publica tags de esta
# versión, así que se descarga del repositorio de releases de Google.
ARG FLUTTER_VERSION=3.47.7
RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      -o /tmp/flutter.tar.xz \
    && mkdir -p /opt \
    && tar -xf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz

ENV PATH="/opt/flutter/bin:${PATH}" \
    CI=true \
    PUB_CACHE=/root/.pub-cache

WORKDIR /app

# pubspec.lock está en .gitignore, así que no existe en el build context.
COPY pubspec.yaml ./
RUN flutter pub get

COPY . .

# La URL del backend se inyecta en build (Coolify: build argument API_BASE_URL).
ARG API_BASE_URL=http://localhost:8000/api/v1
RUN flutter build web --release --dart-define=API_BASE_URL=${API_BASE_URL}

# ---------- Servidor estático ----------
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
