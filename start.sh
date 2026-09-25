#!/bin/sh
# Lancement du relais en arrière-plan avec les logs redirigés
python3 relay.py > relay.log 2>&1 &

# Lancement du serveur HTTP Python au premier plan sur le port de Railway
exec python3 -m http.server ${PORT:-8080}
