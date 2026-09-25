#!/bin/sh
python3 relay.py &
python3 -m http.server 8080
