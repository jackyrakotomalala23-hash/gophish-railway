FROM gophish/gophish:latest

USER root

# Installer Python 3 et les outils nécessaires
RUN apt-get update && apt-get install -y python3

# Copier le script de relais
COPY relay.py /app/relay.py

# Créer le script de démarrage en supprimant l'ancienne base si besoin pour forcer la regénération
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'rm -f /app/gophish.db' >> /app/entrypoint.sh && \
    echo 'python3 /app/relay.py &' >> /app/entrypoint.sh && \
    echo './gophish' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
