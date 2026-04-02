# 🔬 Application de Réservation d'Équipements de Laboratoire

Une application web moderne et complète pour gérer les réservations d'équipements de laboratoire.

## ✨ Fonctionnalités

- ✅ **9 équipements gérés**
  - 5 Étuves thermiques
  - 1 Chambre RF (radioélectrique)
  - 3 Bancs de test automatiques

- ✅ **Réservation intuitive**
  - Sélection facile de l'équipement et des créneaux horaires
  - Validation en temps réel des disponibilités
  - Détection automatique des conflits d'horaires

- ✅ **Calendrier interactif**
  - Vue des 14 prochains jours
  - Affichage des réservations par jour
  - Filtrage par équipement

- ✅ **Gestion des réservations**
  - Historique complet
  - Filtrage (à venir/passées)
  - Annulation possible
  - Persistance des données en localStorage

- ✅ **Design responsive**
  - Interface élégante et moderne
  - Optimisée pour desktop, tablette et mobile
  - Animations fluides

## 🛠️ Stack Technique

- **Frontend**: HTML5, CSS3, Vue.js 3
- **Backend**: Node.js + Express.js
- **Containerisation**: Docker
- **Déploiement**: Coolify

## 📋 Prérequis

- Docker et Docker Compose (pour la containerisation)
- Node.js 18+ (pour le développement local)

## 🚀 Déploiement sur Coolify

### Étape 1 : Connecter votre dépôt Git

1. Allez sur votre instance Coolify
2. Créez un nouveau projet
3. Connectez votre dépôt Git (GitHub, GitLab, Gitea, etc.)

### Étape 2 : Configuration de l'application

1. Sélectionnez le répertoire du projet
2. Coolify détectera automatiquement le `Dockerfile`
3. Configurez le port (par défaut: 3000)

### Étape 3 : Variables d'environnement (optionnel)

Aucune variable d'environnement requise pour le fonctionnement de base, mais vous pouvez ajouter :

```
PORT=3000
NODE_ENV=production
```

### Étape 4 : Déploiement

1. Cliquez sur "Deploy"
2. Coolify construira et lancera automatiquement le conteneur
3. Votre application sera accessible via l'URL fournie par Coolify

## 💻 Développement Local

### Installation

```bash
npm install
```

### Lancement du serveur de développement

```bash
npm start
```

L'application sera disponible sur `http://localhost:3000`

### Avec Docker Compose

```bash
docker-compose up
```

## 📁 Structure du Projet

```
.
├── index.html          # Page principale (interface Vue.js)
├── app.js              # Logique Vue.js et gestion de l'état
├── style.css           # Feuille de styles
├── server.js           # Serveur Express.js
├── package.json        # Dépendances Node.js
├── Dockerfile          # Configuration Docker
├── docker-compose.yml  # Configuration Docker Compose
├── .gitignore          # Fichiers ignorés par Git
└── README.md           # Ce fichier
```

## 🔧 Configuration de Coolify

### Recommandations de déploiement

- **Protocole**: HTTP/HTTPS (avec reverse proxy)
- **Port interne**: 3000
- **Santé check**: Activé (endpoint `/`)
- **Redémarrage**: Unless-stopped (relancement automatique en cas de crash)

### Ressources recommandées

- **CPU**: 0.25 - 0.5 CPU
- **RAM**: 256 MB - 512 MB
- **Stockage**: 1 GB minimum

## 📱 Utilisation

1. **Accédez à l'application** via l'URL fournie par Coolify
2. **Consultez les équipements** disponibles dans la section "Équipements Disponibles"
3. **Effectuez une réservation**:
   - Sélectionnez l'équipement
   - Choisissez la date et les horaires
   - Entrez vos informations (nom, email)
   - Validez la réservation
4. **Consultez votre historique** dans la section "Historique des Réservations"
5. **Annulez si besoin** une réservation à venir

## 🔒 Sécurité

- Application sans connexion requise (à adapter selon vos besoins)
- Les données sont stockées en localStorage (navigateur client)
- Pour une utilisation en production, considérez :
  - L'ajout d'une authentification
  - La migration vers une base de données (MongoDB, PostgreSQL)
  - L'implémentation d'une API sécurisée

## 📝 Notes

- Les réservations sont stockées localement dans le navigateur
- Chaque navigateur/appareil a ses propres données
- Les données persistent tant que le cache du navigateur n'est pas vidé
- Pour une production robuste, intégrez une base de données

## 🤝 Support

Pour toute question ou signaler un bug, consultez la documentation de Coolify : https://coolify.io

## 📄 Licence

MIT

---

**Créée avec ❤️ pour la gestion d'équipements de laboratoire**
