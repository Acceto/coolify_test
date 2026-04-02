#!/bin/bash

# 🔍 Script de diagnostic des ports et conteneurs

echo "╔════════════════════════════════════════════════════════════╗"
echo "║        🔍 DIAGNOSTIC PORTS & CONTENEURS DOCKER             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Vérifier Docker
echo -e "${BLUE}1️⃣  Docker Status${NC}"
echo "─────────────────────────────────────────────────────────────"
if command -v docker &> /dev/null; then
    if docker ps &> /dev/null; then
        echo -e "${GREEN}✓ Docker is running${NC}"
        echo ""
        echo "Active containers:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo -e "${RED}✗ Docker daemon not responding${NC}"
        echo "Try: sudo systemctl start docker"
    fi
else
    echo -e "${YELLOW}⚠ Docker not installed${NC}"
fi
echo ""

# 2. Vérifier le port 3000 spécifiquement
echo -e "${BLUE}2️⃣  Port 3000 Status${NC}"
echo "─────────────────────────────────────────────────────────────"
if command -v lsof &> /dev/null; then
    PROC=$(lsof -i :3000 2>/dev/null)
    if [ -n "$PROC" ]; then
        echo -e "${YELLOW}⚠ Port 3000 is in use:${NC}"
        echo "$PROC" | tail -n +2 | awk '{printf "  Process: %s (PID: %s)\n", $1, $2}'
    else
        echo -e "${GREEN}✓ Port 3000 is available${NC}"
    fi
elif command -v ss &> /dev/null; then
    PROC=$(ss -tlnp 2>/dev/null | grep ":3000 ")
    if [ -n "$PROC" ]; then
        echo -e "${YELLOW}⚠ Port 3000 is in use:${NC}"
        echo "$PROC"
    else
        echo -e "${GREEN}✓ Port 3000 is available${NC}"
    fi
elif command -v netstat &> /dev/null; then
    PROC=$(netstat -tlnp 2>/dev/null | grep ":3000 ")
    if [ -n "$PROC" ]; then
        echo -e "${YELLOW}⚠ Port 3000 is in use:${NC}"
        echo "$PROC"
    else
        echo -e "${GREEN}✓ Port 3000 is available${NC}"
    fi
else
    echo -e "${YELLOW}⚠ No port checking tool available${NC}"
fi
echo ""

# 3. Node.js processes
echo -e "${BLUE}3️⃣  Node.js Processes${NC}"
echo "─────────────────────────────────────────────────────────────"
if pgrep -f "node" > /dev/null; then
    echo -e "${YELLOW}Running Node processes:${NC}"
    ps aux | grep "node" | grep -v grep | awk '{printf "  PID: %s | Command: %s %s %s\n", $2, $11, $12, $13}'
else
    echo -e "${GREEN}✓ No Node.js processes running${NC}"
fi
echo ""

# 4. All listening ports
echo -e "${BLUE}4️⃣  All Listening Ports${NC}"
echo "─────────────────────────────────────────────────────────────"
if command -v ss &> /dev/null; then
    echo "TCP Listening ports:"
    ss -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | sort | sed 's/^/  /'
elif command -v netstat &> /dev/null; then
    echo "TCP Listening ports:"
    netstat -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | sort | sed 's/^/  /'
fi
echo ""

# 5. Docker images
echo -e "${BLUE}5️⃣  Docker Images${NC}"
echo "─────────────────────────────────────────────────────────────"
if command -v docker &> /dev/null; then
    if docker images &> /dev/null; then
        IMAGES=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null)
        if [ -n "$IMAGES" ]; then
            echo "$IMAGES"
        else
            echo -e "${YELLOW}⚠ No Docker images found${NC}"
        fi
    fi
fi
echo ""

# 6. Docker volumes
echo -e "${BLUE}6️⃣  Docker Volumes${NC}"
echo "─────────────────────────────────────────────────────────────"
if command -v docker &> /dev/null; then
    if docker volume ls &> /dev/null; then
        VOLS=$(docker volume ls --format "table {{.Name}}\t{{.Driver}}" 2>/dev/null)
        if [ -n "$VOLS" ]; then
            echo "$VOLS"
        else
            echo -e "${GREEN}✓ No Docker volumes${NC}"
        fi
    fi
fi
echo ""

# 7. Docker networks
echo -e "${BLUE}7️⃣  Docker Networks${NC}"
echo "─────────────────────────────────────────────────────────────"
if command -v docker &> /dev/null; then
    if docker network ls &> /dev/null; then
        docker network ls --format "table {{.Name}}\t{{.Driver}}"
    fi
fi
echo ""

# 8. Summary
echo -e "${BLUE}📊 Summary${NC}"
echo "─────────────────────────────────────────────────────────────"
echo -e "${GREEN}✓ Use this info to diagnose deployment issues${NC}"
echo -e "${YELLOW}Common issues:${NC}"
echo "  • Port 3000 occupied → Kill the process or change port"
echo "  • No Docker running → Start Docker service"
echo "  • Stale containers → Clean up with 'docker system prune'"
echo ""
