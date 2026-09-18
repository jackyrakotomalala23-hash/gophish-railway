FROM gophish/gophish:latest
RUN sed -i 's/127.0.0.1:3333/0.0.0.0:3333/g' config.json && \
    sed -i 's/"use_tls": false/"use_tls": true/g' config.json
EXPOSE 3333 80
