FROM gophish/gophish:latest

USER root

# Installation de Nginx
RUN apt-get update && apt-get install -y nginx

# Suppression de la configuration par défaut
RUN rm -f /etc/nginx/sites-enabled/default

# Configuration du reverse proxy Nginx vers Gophish HTTPS (port 3333)
RUN printf 'server {\n\
    listen 8080;\n\
    location / {\n\
        proxy_pass https://127.0.0.1:3333;\n\
        proxy_ssl_verify off;\n\
        proxy_set_header Host $host;\n\
        proxy_set_header X-Real-IP $remote_addr;\n\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n\
        proxy_set_header X-Forwarded-Proto https;\n\
    }\n\
}\n' > /etc/nginx/conf.d/gophish.conf

# Création propre du script de démarrage
RUN printf '#!/bin/sh\nnginx\nexec ./gophish\n' > /opt/gophish/entrypoint.sh && chmod +x /opt/gophish/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/opt/gophish/entrypoint.sh"]
