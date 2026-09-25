#!/bin/sh
python3 relay.py &
cd /app
python3 -m http.server ${PORT:-8080}
