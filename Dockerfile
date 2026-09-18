FROM gophish/gophish:latest

USER root
RUN apt-get update && apt-get install -y caddy

RUN sed -i 's/127.0.0.1:3333/127.0.0.1:3333/g' /opt/gophish/config.json && \
    sed -i 's/"use_tls": true/"use_tls": false/g' /opt/gophish/config.json

RUN echo '#!/bin/sh\n\
caddy reverse-proxy --from :8080 --to 127.0.0.1:3333 --header-up Referer "http://127.0.0.1:3333" &\n\
exec ./gophish\n' > /opt/gophish/entrypoint.sh && chmod +x /opt/gophish/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/opt/gophish/entrypoint.sh"]
