FROM gophish/gophish:latest

USER root

# Configuration directe de Gophish sur le port 8080 sans TLS
RUN echo '{"admin_server":{"listen_url":"0.0.0.0:8080","use_tls":false,"cert_path":"gophish_admin.crt","key_path":"gophish_admin.key","trusted_origins":["gophish-railway-production-2e49.up.railway.app"]},"phish_server":{"listen_url":"0.0.0.0:8000","use_tls":false,"cert_path":"example.crt","key_path":"example.key"},"db_name":"sqlite3","db_path":"gophish.db","migrations_prefix":"db/db_","logging":{"filename":"","level":""}}' > /opt/gophish/config.json

EXPOSE 8080

RUN apk add --no-cache python3

ENTRYPOINT ["./start.sh"]
