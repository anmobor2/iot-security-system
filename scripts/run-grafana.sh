#!/bin/bash
docker run -d -p 3000:3000 --name grafana \
  -e "GF_AUTH_ANONYMOUS_ENABLED=true" \
  grafana/grafana:11.2.0