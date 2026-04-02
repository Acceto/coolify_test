# 🚀 Guide de Déploiement sur Coolify

## Configuration pour Coolify

Ce projet est prêt à être déployé sur **Coolify** (self-hosted PaaS).

### Étapes de déploiement

#### 1️⃣ Préparer votre dépôt Git

```bash
# Assurez-vous que tous les fichiers sont commitées
git add -A
git commit -m "Ajout de la configuration Coolify"
git push
```

#### 2️⃣ Sur Coolify

1. **Accédez à votre instance Coolify** (ex: https://your-coolify-instance.com)
2. **Créez un nouveau projet**
3. **Connectez votre dépôt Git**
   - Choisissez votre plateforme (GitHub, GitLab, Gitea, etc.)
   - Authentifiez-vous
   - Sélectionnez le dépôt `coolify_test`

4. **Configuration de l'application**
   - **Type**: Docker
   - **Dockerfile**: `Dockerfile` ✓ (détecté automatiquement)
   - **Port**: `3000` ✓ (configuré dans Dockerfile)
   - **Redémarrage**: `unless-stopped` (relancement automatique)

5. **Ports et Networking**
   - Port interne: `3000`
   - Exposé sur Internet: Activé
   - Coolify génèrera une URL publique

6. **Déployer**
   - Cliquez sur "Deploy"
   - Coolify construira le conteneur Docker
   - L'application sera automatiquement démarrée

### Variables d'environnement (optionnel)

Aucune variable d'environnement requise pour le fonctionnement de base.

Pour la production, vous pouvez ajouter :
```
NODE_ENV=production
PORT=3000
```

### Health Check

Un health check est configuré dans le Dockerfile :
- Intervalle: 30 secondes
- Timeout: 3 secondes
- Relances avant redémarrage: 3
- Délai de démarrage: 5 secondes

### SSL/TLS

Coolify offrira automatiquement une URL HTTPS sécurisée.

### Logs et Monitoring

Dans l'interface Coolify, vous pouvez :
- Consulter les logs en temps réel
- Monitorer l'utilisation des ressources
- Voir l'historique des déploiements
- Redémarrer l'application si besoin

### Dépannage

**L'application ne démarre pas?**
- Vérifiez les logs dans Coolify
- Assurez-vous que tous les fichiers (Dockerfile, package.json, server.js, index.html, app.js, style.css) sont présents
- Vérifiez que le port 3000 n'est pas utilisé

**Port déjà utilisé?**
- Coolify gère automatiquement le port interne
- Vous pouvez configurer un port différent dans les paramètres

**Les réservations disparaissent?**
- Les données sont stockées en localStorage (navigateur client)
- Pour la persistence, intégrez une base de données (voir README.md)

### Mise à jour de l'application

1. Effectuez vos changements en local
2. Committez et pushez sur Git
3. Coolify détectera automatiquement les changements
4. Redéploiement automatique ou manuel disponible

### Recommandations de sécurité

Pour une utilisation en production :

1. **Authentification**
   - Ajoutez un système de login
   - Implémentez des tokens JWT

2. **Base de données**
   - Intégrez MongoDB ou PostgreSQL
   - Migrez le stockage localStorage vers une DB

3. **CORS/HTTPS**
   - Coolify configure HTTPS automatiquement
   - Configurez les headers de sécurité

4. **Backups**
   - Si vous ajoutez une DB, configurez les backups réguliers

### Support Coolify

- Documentation: https://coolify.io/docs
- Forum: https://community.coolify.io
- GitHub: https://github.com/coollabsio/coolify

---

**Prêt à déployer? 🎉 C'est parti!**
