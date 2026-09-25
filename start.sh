#!/bin/sh
echo "Démarrage du script relay..."
python3 relay.py &
echo "Démarrage du serveur HTTP sur le port ${PORT:-8080}..."
cd /app
python3 -m http.server ${PORT:-8080}
