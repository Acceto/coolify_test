# 🐳 Guide des Commandes Docker & Diagnostic

## 🔍 Vérifier les Conteneurs & Ports

### Lister les conteneurs actifs
```bash
# Tous les conteneurs actifs
docker ps

# Tous les conteneurs (y compris arrêtés)
docker ps -a

# Format personnalisé avec plus de détails
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Conteneurs filtrés par nom
docker ps -f name=reservation
```

### Vérifier les ports en utilisation

#### Option 1 : Avec `lsof` (meilleure approche)
```bash
# Voir qui utilise le port 3000
lsof -i :3000

# Voir tous les ports écoutant
lsof -i -P -n | grep LISTEN
```

#### Option 2 : Avec `ss` (socket statistics)
```bash
# Port 3000 spécifique
ss -tlnp | grep :3000

# Tous les ports écoutant
ss -tlnp
```

#### Option 3 : Avec `netstat` (ancien mais encore utile)
```bash
# Port 3000
netstat -tlnp | grep :3000

# Tous les TCP écoutant
netstat -tlnp | grep LISTEN
```

### Trouver le processus utilisant un port

```bash
# Quick: Lsof
PID=$(lsof -t -i :3000)
echo "Process using port 3000: $PID"

# Tuer le processus
kill -9 $PID

# Ou directement
lsof -ti :3000 | xargs kill -9
```

## 🔧 Diagnostic du Script

### Exécuter le script de diagnostic
```bash
# Rendre exécutable
chmod +x check-ports.sh

# Exécuter
./check-ports.sh
```

Le script vérifie :
- ✅ État de Docker
- ✅ Port 3000 disponible
- ✅ Processus Node.js actifs
- ✅ Tous les ports écoutant
- ✅ Images Docker
- ✅ Volumes Docker
- ✅ Réseaux Docker

## 🧹 Nettoyage Docker

### Arrêter les conteneurs
```bash
# Arrêter un conteneur spécifique
docker stop reservation-labo

# Arrêter tous les conteneurs
docker stop $(docker ps -q)

# Arrêter et supprimer
docker rm reservation-labo
```

### Nettoyage complet
```bash
# Supprimer les images inutilisées
docker image prune

# Supprimer les volumes inutilisés
docker volume prune

# Nettoyage complet du système
docker system prune -a

# Avec confirmation automatique
docker system prune -a --force
```

### Voir les logs des conteneurs
```bash
# Logs d'un conteneur
docker logs reservation-labo

# Logs en temps réel (follow)
docker logs -f reservation-labo

# Dernières 50 lignes
docker logs --tail 50 reservation-labo

# Avec timestamps
docker logs -t reservation-labo
```

## 🚀 Contrôle Docker Compose

### Démarrer l'app
```bash
# Démarrer
docker-compose up

# En arrière-plan
docker-compose up -d

# Reconstruire les images
docker-compose up --build

# Forcer la reconstruction
docker-compose up --build --force-recreate
```

### Arrêter l'app
```bash
# Arrêter
docker-compose stop

# Arrêter et supprimer les conteneurs
docker-compose down

# Supprimer aussi les volumes
docker-compose down -v

# Supprimer aussi les images
docker-compose down --rmi all
```

### Logs et Monitoring
```bash
# Voir les logs
docker-compose logs

# Suivre les logs en temps réel
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs app

# Stats en temps réel
docker stats
```

## 🐛 Diagnostiquer les Problèmes

### Cas 1 : Port déjà utilisé
```bash
# Trouver le processus
lsof -i :3000

# Tuer le processus
kill -9 <PID>

# Ou changer le port dans docker-compose.yml
```

### Cas 2 : Conteneur qui crash immédiatement
```bash
# Voir les logs
docker logs -f reservation-labo

# Vérifier l'inspection du conteneur
docker inspect reservation-labo

# Voir l'exit code
docker inspect --format='{{.State.ExitCode}}' reservation-labo
```

### Cas 3 : Health check échoue
```bash
# Vérifier le health status
docker inspect --format='{{.State.Health}}' reservation-labo

# Voir les logs du health check
docker inspect --format='{{json .State}}' reservation-labo | jq .Health
```

### Cas 4 : Fichiers manquants
```bash
# Vérifier les fichiers dans le conteneur
docker exec reservation-labo ls -la

# Copier un fichier depuis le conteneur
docker cp reservation-labo:/app/server.js ./

# Inspecter l'image
docker history reservation-labo:latest
```

## 📊 Monitoring en Production

### Sur Coolify

#### Via CLI SSH
```bash
# Se connecter à votre serveur Coolify
ssh user@your-coolify-server

# Voir les conteneurs
docker ps

# Logs de votre app
docker logs -f <container-id>

# Stats
docker stats <container-id>
```

#### Via Interface Coolify
1. **Projet** → Sélectionnez votre app
2. **Onglet "Logs"** - Voir les logs en temps réel
3. **Onglet "Monitor"** - CPU, RAM, I/O
4. **Onglet "Settings"** - Logs, healthcheck, variables

## 🔗 Ressources Utiles

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Coolify Docs - Docker](https://coolify.io/docs/docker)
- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)

---

**💡 Tip:** Gardez ce guide à proximité pour le debugging ! 🔧
