FROM gophish/gophish:latest
WORKDIR /opt/gophish
EXPOSE 8080 80
CMD ["./gophish"]
