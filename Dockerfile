FROM python:3.9-slim
WORKDIR /app
COPY . /app
RUN chmod +x start.sh
EXPOSE 8080
CMD ["./start.sh"]
