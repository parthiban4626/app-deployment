#!/bin/bash
docker rm -f react-app-container || true
docker pull parthiban46/dev-app:latest
docker run -d \
  --name react-app-container \
  -p 80:80 \
  parthiban46/dev-app:latest
