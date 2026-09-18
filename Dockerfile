FROM gophish/gophish:latest

USER root

# Installation de Nginx
RUN apt-get update && apt-get install -y nginx

# Configuration de Gophish en HTTP local
RUN sed -i 's/"use_tls": true/"use_tls": false/g' /opt/gophish/config.json

# Configuration Nginx pour le port 8080 et la réécriture du Referer
RUN echo 'server { \
    listen 8080; \
    location / { \
        proxy_pass http://127.0.0.1:3333; \
        proxy_set_header Host $host; \
        proxy_set_header Referer "http://127.0.0.1:3333"; \
    } \
}' > /etc/nginx/sites-available/default

# Script de démarrage
RUN echo '#!/bin/sh\n\
service nginx start\n\
exec ./gophish\n' > /opt/gophish/entrypoint.sh && chmod +x /opt/gophish/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/opt/gophish/entrypoint.sh"]
