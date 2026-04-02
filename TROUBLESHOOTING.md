# 🔧 Guide de Dépannage Coolify

## Problème : Application "running" mais ne répond pas

### 🔍 Diagnostic sur Coolify

#### Étape 1 : Vérifier les logs
1. Allez dans votre **projet Coolify**
2. Cliquez sur l'onglet **"Logs"** ou **"Container Logs"**
3. Regardez les dernières lignes pour voir les erreurs

#### Étape 2 : Rechercher des erreurs courantes

**Erreur : "Cannot find module 'express'"**
```
Solution : Les dépendances n'ont pas été installées
- Attendez que npm install finisse (peut prendre 1-2 min)
- Forcez un redéploiement
```

**Erreur : "Port already in use"**
```
Solution : Le port 3000 est occupé
- Coolify gère normalement cela automatiquement
- Vérifiez qu'il n'y a qu'un seul conteneur actif
```

**Erreur : "ENOENT: no such file or directory"**
```
Solution : Les fichiers n'ont pas été copiés correctement
- Vérifiez que tous les fichiers sont pushés sur Git
- Vérifiez le .gitignore n'exclut pas les fichiers nécessaires
```

**Erreur : "Health check failed"**
```
Solution : Le serveur démarre mais le health check échoue
- Attendez 10-15 secondes (startup period)
- Vérifiez que curl est disponible dans l'image Docker
- Consultez les logs pour les erreurs réelles
```

### ✅ Checklist de diagnostic

- [ ] **Logs Coolify consultés** - Voir les erreurs exactes
- [ ] **Fichiers corrects pushés** - Tous les fichiers sont sur GitHub
  ```bash
  git status
  git log --oneline -5
  ```

- [ ] **Package.json valide** - Structure correcte JSON
  ```bash
  cat package.json
  ```

- [ ] **Dockerfile valide** - Pas d'erreur de syntaxe
  ```bash
  docker build -t test .
  ```

- [ ] **Serveur démarre localement** - Fonctionne en développement
  ```bash
  npm install
  npm start
  ```

### 🐳 Test avec Docker Compose

```bash
# Construire et lancer
docker-compose up --build

# Vérifier si ça fonctionne
curl http://localhost:3000

# Voir les logs
docker-compose logs -f

# Arrêter
docker-compose down
```

### 📝 Vérification des fichiers Git

```bash
# Vérifier que les fichiers sont bien pushés
git ls-files | grep -E "\.(json|js|html|css|md|Dockerfile|dockerignore|gitignore)$"

# Vérifier le statut
git status

# Voir le dernier commit
git log --name-status -1
```

### 🚀 Redéployer après correction

1. **Effectuez vos corrections locales**
   ```bash
   # Exemple : corriger server.js
   nano server.js
   ```

2. **Committez et poussez**
   ```bash
   git add -A
   git commit -m "Fix: [description du problème]"
   git push origin main
   ```

3. **Sur Coolify**
   - Allez dans votre projet
   - Cliquez sur "Redeploy" (ou attendez le déploiement automatique)
   - Vérifiez les logs

### 🔗 Endpoints pour tester

Une fois déployé, testez ces endpoints :

```bash
# Page d'accueil
curl https://your-coolify-url.com/

# Health check
curl https://your-coolify-url.com/health

# Fichiers statiques
curl https://your-coolify-url.com/app.js
curl https://your-coolify-url.com/style.css
```

### 💡 Astuces Coolify

**Activer le debug mode**
- Dans les paramètres du projet, activez les logs détaillés
- Cela affichera plus d'informations de diagnostic

**Vérifier les ressources**
- Allez dans "Monitor" ou "Resources"
- Vérifiez que le conteneur a assez de CPU/RAM
- Vérifiez qu'il n'y a pas de redémarrages en boucle

**Voir les variables d'environnement**
- Onglet "Environment" ou "Settings"
- Vérifiez que `PORT` et `NODE_ENV` sont configurés correctement

### 🆘 Si ça ne fonctionne toujours pas

**Collectez ces informations et partagez :**

1. **Contenu des logs Coolify** (dernières 50 lignes)
2. **Output de cette commande locale** :
   ```bash
   npm install && npm start
   ```
3. **Contenu de votre package.json**
4. **Contenu de votre Dockerfile**
5. **Le message exact d'erreur** (s'il y en a un)

### 📚 Ressources utiles

- [Documentation Coolify - Docker](https://coolify.io/docs/docker)
- [Documentation Coolify - Troubleshooting](https://coolify.io/docs/troubleshooting)
- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)

---

**Les logs Coolify sont votre meilleur ami !** 📊
