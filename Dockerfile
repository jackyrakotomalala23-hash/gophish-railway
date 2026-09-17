FROM golang:alpine AS builder
RUN apk add --no-cache git make
RUN git clone https://github.com/gophish/gophish.git /app/gophish
WORKDIR /app/gophish
RUN go build -o gophish

FROM alpine:latest
WORKDIR /opt/gophish
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/gophish/gophish /opt/gophish/
COPY --from=builder /app/gophish/static /opt/gophish/static
COPY --from=builder /app/gophish/templates /opt/gophish/templates
COPY config.json /opt/gophish/config.json
EXPOSE 3333 80
CMD ["./gophish"]
