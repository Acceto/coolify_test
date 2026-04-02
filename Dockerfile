# Builder stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copier package.json et package-lock.json (s'il existe)
COPY package*.json ./

# Installer les dépendances
RUN npm install --production

# Production stage
FROM node:18-alpine

WORKDIR /app

# Installer dumb-init pour gérer les signaux
RUN apk add --no-cache dumb-init

# Copier les dépendances du stage builder
COPY --from=builder /app/node_modules ./node_modules

# Copier les fichiers de l'application
COPY package.json .
COPY server.js .
COPY index.html .
COPY app.js .
COPY style.css .

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Changer la propriété des fichiers
RUN chown -R nodejs:nodejs /app

# Basculer vers l'utilisateur nodejs
USER nodejs

# Exposer le port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Utiliser dumb-init pour lancer l'application
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
