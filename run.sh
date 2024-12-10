#!/usr/bin/env bash
set -e

URL=$(jq -r '.url' /data/options.json)
TOKEN=$(jq -r '.token' /data/options.json)

DASHBOARD_URL="$URL" HA_TOKEN="$TOKEN" node /screenshot.js

echo "Screenshot taken and saved to /config/www/dashboard_screenshot.png"
