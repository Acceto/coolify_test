#!/bin/bash

echo "🧪 Test local de l'application"
echo "================================"

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier Node.js
echo -e "${YELLOW}1. Vérification de Node.js...${NC}"
if command -v node &> /dev/null; then
    echo -e "${GREEN}✓ Node.js installé:$(node -v)${NC}"
else
    echo -e "${RED}✗ Node.js non trouvé${NC}"
    exit 1
fi

# Vérifier npm
echo -e "${YELLOW}2. Vérification de npm...${NC}"
if command -v npm &> /dev/null; then
    echo -e "${GREEN}✓ npm installé: $(npm -v)${NC}"
else
    echo -e "${RED}✗ npm non trouvé${NC}"
    exit 1
fi

# Vérifier les fichiers
echo -e "${YELLOW}3. Vérification des fichiers...${NC}"
FILES=("package.json" "server.js" "index.html" "app.js" "style.css")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file trouvé${NC}"
    else
        echo -e "${RED}✗ $file manquant${NC}"
        exit 1
    fi
done

# Installer les dépendances
echo -e "${YELLOW}4. Installation des dépendances...${NC}"
if npm install; then
    echo -e "${GREEN}✓ Dépendances installées${NC}"
else
    echo -e "${RED}✗ Erreur lors de l'installation${NC}"
    exit 1
fi

# Tester le serveur
echo -e "${YELLOW}5. Démarrage du serveur de test...${NC}"
timeout 5 node server.js &
SERVER_PID=$!
sleep 2

# Vérifier si le serveur répond
echo -e "${YELLOW}6. Test de la connexion...${NC}"
if command -v curl &> /dev/null; then
    if curl -f http://localhost:3000/ > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Serveur répond correctement${NC}"
    else
        echo -e "${RED}✗ Serveur ne répond pas${NC}"
        kill $SERVER_PID 2>/dev/null
        exit 1
    fi
else
    echo -e "${YELLOW}! curl non disponible, test skippé${NC}"
fi

# Arrêter le serveur
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}✓ Tous les tests réussis!${NC}"
echo -e "${GREEN}L'application est prête à être déployée${NC}"
echo -e "${GREEN}================================${NC}"
