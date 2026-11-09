#!/bin/bash
# Run on a server to deploy the latest website version from Git.
# Usage: sudo ./deploy.sh

set -e
APP_DIR="/opt/park-website"
WEB_DIR="/var/www/html"

cd "$APP_DIR"
git pull
cp index.html style.css health "$WEB_DIR"/
echo "Deployed: $(git rev-parse --short HEAD)"
