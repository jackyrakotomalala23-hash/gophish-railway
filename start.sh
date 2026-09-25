#!/bin/sh
python3 relay.py &
exec python3 -m http.server ${PORT:-8080}
