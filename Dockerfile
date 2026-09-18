FROM gophish/gophish:latest

RUN sed -i 's/127.0.0.1:3333/0.0.0.0:3333/g' /opt/gophish/config.json

EXPOSE 3333 80
