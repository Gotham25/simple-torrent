#!/bin/bash

CLOUD_TORRENT_BINARY="cloud-torrent"

if [ ! -f "${CLOUD_TORRENT_BINARY}" ]; then
  echo "Error ${CLOUD_TORRENT_BINARY} is not present in current directory"
  exit 1
fi

PORT_OPT=""
AUTHENTICATION_OPT=""

if [ ! -z "$PORT" ]; then
  PORT_OPT="--port $PORT"
fi

if [ ! -z "$AUTHENTICATED" ] && [ "$AUTHENTICATED" == "yes" ]; then
  echo "Authentication is set. Checking for username and password set in environment...";
  if [ -z "$AUTH_USERNAME" ] || [ -z "$AUTH_PASSWORD" ]; then
    echo "Either username (or) password is not set in environment. Skipping authentication configuration..."
  else
    AUTHENTICATION_OPT="--auth \"${AUTH_USERNAME}:${AUTH_PASSWORD}\""
  fi
else
  echo "Autentication is not set. Skipping authentication configuration..."
fi

echo -e "Starting cloud torrent...\n"

${CLOUD_TORRENT_BINARY} ${PORT_OPT} ${AUTHENTICATION_OPT}
