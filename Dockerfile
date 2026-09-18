FROM gophish/gophish:latest

USER root

# Installation de Nginx
RUN apt-get update && apt-get install -y nginx

# Configuration Nginx HTTPS vers 127.0.0.1:3333
RUN echo 'server { \
    listen 8080; \
    location / { \
        proxy_pass https://127.0.0.1:3333; \
        proxy_ssl_verify off; \
        proxy_set_header Host $host; \
        proxy_set_header Referer "https://127.0.0.1:3333"; \
        proxy_set_header X-Real-IP $remote_addr; \
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \
        proxy_set_header X-Forwarded-Proto https; \
    } \
}' > /etc/nginx/sites-available/default

# Script de démarrage
RUN echo '#!/bin/sh\n\
service nginx start\n\
exec ./gophish\n' > /opt/gophish/entrypoint.sh && chmod +x /opt/gophish/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/opt/gophish/entrypoint.sh"]
