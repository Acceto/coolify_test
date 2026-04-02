# Builder stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copier package.json et package-lock.json (s'il existe)
COPY package*.json ./

# Installer les dépendances
RUN npm ci --only=production || npm install --production

# Production stage
FROM node:18-alpine

WORKDIR /app

# Installer curl et dumb-init pour les health checks et la gestion des signaux
RUN apk add --no-cache dumb-init curl

# Copier les dépendances du stage builder
COPY --from=builder /app/node_modules ./node_modules

# Copier les fichiers de l'application
COPY package.json .
COPY server.js .
COPY index.html .
COPY app.js .
COPY style.css .

# Changer la propriété des fichiers (avant de basculer d'utilisateur)
RUN chown -R 1000:1000 /app && chmod -R 755 /app

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1000 -S appuser && \
    adduser -S appuser -u 1000 -G appuser

# Basculer vers l'utilisateur appuser
USER appuser

# Exposer le port
EXPOSE 3000

# Health check avec curl (plus fiable)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Utiliser dumb-init pour lancer l'application
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
