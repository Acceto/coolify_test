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

# Changer la propriété des fichiers vers l'utilisateur node (existe déjà)
RUN chown -R node:node /app && chmod -R 755 /app

# Basculer vers l'utilisateur node (non-root)
USER node

# Exposer le port
EXPOSE 3010

# Health check avec curl (plus fiable)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3010/ || exit 1

# Utiliser dumb-init pour lancer l'application
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
