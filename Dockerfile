FROM gophish/gophish:latest

USER root

# Mettre à jour et installer Python 3 pour les images basées sur Debian
RUN apt-get update && apt-get install -y python3

# Copier le script de relais
COPY relay.py /app/relay.py

# Créer le script de démarrage interne
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'python3 /app/relay.py &' >> /app/entrypoint.sh && \
    echo './gophish' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
