#!/bin/bash

# 🧹 Script de nettoyage Docker pour Coolify

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           🧹 NETTOYAGE DOCKER & COOLIFY                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vérifier Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not installed${NC}"
    exit 1
fi

# Menu
echo -e "${BLUE}Choisissez une action:${NC}"
echo ""
echo "1) Arrêter et supprimer le conteneur 'reservation-labo'"
echo "2) Supprimer toutes les images inutilisées"
echo "3) Supprimer tous les volumes inutilisés"
echo "4) Nettoyage complet du système Docker"
echo "5) Voir les logs du conteneur"
echo "6) Redémarrer le conteneur"
echo "7) Quitter"
echo ""
read -p "Sélection (1-7): " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Arrêt du conteneur reservation-labo...${NC}"
        docker stop reservation-labo 2>/dev/null
        echo -e "${YELLOW}Suppression du conteneur...${NC}"
        docker rm reservation-labo 2>/dev/null
        echo -e "${GREEN}✓ Conteneur supprimé${NC}"
        ;;
    2)
        echo ""
        echo -e "${YELLOW}Nettoyage des images inutilisées...${NC}"
        docker image prune -a -f
        echo -e "${GREEN}✓ Images inutilisées supprimées${NC}"
        ;;
    3)
        echo ""
        echo -e "${YELLOW}Nettoyage des volumes inutilisés...${NC}"
        docker volume prune -f
        echo -e "${GREEN}✓ Volumes inutilisés supprimés${NC}"
        ;;
    4)
        echo ""
        echo -e "${YELLOW}⚠️  Nettoyage COMPLET du système Docker${NC}"
        read -p "Êtes-vous sûr? (y/n): " confirm
        if [[ $confirm == "y" ]]; then
            docker system prune -a -f --volumes
            echo -e "${GREEN}✓ Système Docker nettoyé${NC}"
        else
            echo -e "${YELLOW}✗ Annulé${NC}"
        fi
        ;;
    5)
        echo ""
        echo -e "${YELLOW}Logs du conteneur reservation-labo:${NC}"
        echo ""
        if docker logs reservation-labo 2>/dev/null; then
            :
        else
            echo -e "${RED}Conteneur non trouvé${NC}"
        fi
        ;;
    6)
        echo ""
        echo -e "${YELLOW}Redémarrage du conteneur...${NC}"
        if docker restart reservation-labo 2>/dev/null; then
            echo -e "${GREEN}✓ Conteneur redémarré${NC}"
            sleep 2
            echo -e "${YELLOW}État du conteneur:${NC}"
            docker ps -f name=reservation-labo
        else
            echo -e "${RED}✗ Conteneur non trouvé${NC}"
        fi
        ;;
    7)
        echo -e "${GREEN}Au revoir! 👋${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}✗ Choix invalide${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}État du système Docker:${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
