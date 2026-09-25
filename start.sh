#!/bin/sh
python3 relay.py &
python3 -c "
import http.server
import socketserver
import os

PORT = int(os.environ.get('PORT', 8080))
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(('0.0.0.0', PORT), Handler) as httpd:
    print(f'Serveur web actif sur le port {PORT}')
    httpd.serve_forever()
"
