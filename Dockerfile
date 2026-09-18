FROM gophish/gophish:latest
WORKDIR /opt/gophish
COPY config.json /opt/gophish/config.json
EXPOSE 8080 80
CMD ["./gophish"]
