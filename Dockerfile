FROM gophish/gophish:latest
RUN sed -i 's/"use_tls": true/"use_tls": false/g' config.json
EXPOSE 3333 80
