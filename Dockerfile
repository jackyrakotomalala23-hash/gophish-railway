FROM gophish/gophish:latest
EXPOSE 8080 80
CMD ["./gophish", "--admin-server=0.0.0.0:8080"]
