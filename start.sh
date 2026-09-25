#!/bin/sh
python3 relay.py &
python3 -m http.server 0.0.0.0:${PORT:-8080}
