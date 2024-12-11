#!/usr/bin/env bash
set -e

# Check if options.json exists
if [ ! -f /data/options.json ]; then
  echo "Error: /data/options.json not found."
  exit 1
fi

# Read URL, token, and output directory from options
URL=$(jq -r '.url' /data/options.json)
TOKEN=$(jq -r '.token' /data/options.json)
OUTPUT_DIR=$(jq -r '.output_dir' /data/options.json)

# Validate the configuration
if [ -z "$URL" ] || [ -z "$TOKEN" ] || [ -z "$OUTPUT_DIR" ]; then
  echo "Error: Missing required configuration parameters."
  exit 1
fi

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Run the screenshot script
DASHBOARD_URL="$URL" HA_TOKEN="$TOKEN" OUTPUT_DIR="$OUTPUT_DIR" node /app/screenshot.js

echo "Screenshot taken and saved to $OUTPUT_DIR/dashboard_screenshot.png"
