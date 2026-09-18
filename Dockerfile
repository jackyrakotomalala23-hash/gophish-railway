FROM gophish/gophish:latest
WORKDIR /opt/gophish
EXPOSE 8080 80
CMD ["./gophish", "--admin-server", "0.0.0.0:8080"]
