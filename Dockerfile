FROM gophish/gophish:latest

USER root

# Installer Python 3
RUN apk add --no-cache python3

# Copier le script de relais dans le conteneur
COPY relay.py /app/relay.py

# Créer un script de lancement interne et le rendre exécutable
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'python3 /app/relay.py &' >> /app/entrypoint.sh && \
    echo './gophish' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

WORKDIR /app

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
