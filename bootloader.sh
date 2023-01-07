#!/bin/bash

function download_latest_release() {
  eval "curl -s https://api.github.com/repos/$1/releases/latest | grep browser_download_url | grep $2 | cut -d : -f 2,3 | tr -d \\\" | wget -qi -"
}

OS_ARCHITECTURE="386"

ARTIFACT_NAME="cloud-torrent_linux_${OS_ARCHITECTURE}_static"

echo "Downloading artifact, $ARTIFACT_NAME.gz"
download_latest_release boypt/simple-torrent "${OS_ARCHITECTURE}"
echo "Artifact $ARTIFACT_NAME.gz downloaded successfully"

echo "Unzipping Artifact $ARTIFACT_NAME.gz"
gunzip "$ARTIFACT_NAME.gz"
echo "Artifact $ARTIFACT_NAME.gz unzipped successfully"

chmod +x $ARTIFACT_NAME
mv "$ARTIFACT_NAME" cloud-torrent

echo "Starting up cloud-torrent..."

export PATH="$(pwd):${PATH}"
chmod +x startCloudTorrent.sh && ./startCloudTorrent.sh

