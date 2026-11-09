#!/bin/bash
# EC2 User data for the web servers (Ubuntu). Runs once, as root, on first boot.
# Typical practice: the website lives in a Git repo, and the server pulls it.

set -e

REPO_URL="https://github.com/Manojgithub01/park-website.git"   
APP_DIR="/opt/park-website"
WEB_DIR="/var/www/html"

apt-get update -y
apt-get install -y nginx git curl

# Get the website code
git clone "$REPO_URL" "$APP_DIR"

# Publish it
rm -f "$WEB_DIR/index.nginx-debian.html"
cp -r "$APP_DIR"/. "$WEB_DIR"/
rm -rf "$WEB_DIR/.git"

# Write which instance and zone served the page (read by index.html)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "$ID ($AZ)" > "$WEB_DIR/instance.txt"

systemctl enable nginx
systemctl restart nginx
