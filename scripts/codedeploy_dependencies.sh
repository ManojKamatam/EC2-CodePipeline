#!/bin/bash

LOG_FILE="/var/log/codedeploy_dependencies.log"
APP_DIR="/var/www/myapp"
DEPLOY_ROOT="/opt/codedeploy-agent/deployment-root"

echo "Installing application dependencies..." >> "$LOG_FILE"

# Locate deployment-archive
DEPLOY_DIR=$(find "$DEPLOY_ROOT" -type d -name "deployment-archive" | head -n 1)
if [ -z "$DEPLOY_DIR" ]; then
    echo "Error: Deployment directory (deployment-archive) not found under $DEPLOY_ROOT." >> "$LOG_FILE"
    exit 1
fi

APP_ZIP="$DEPLOY_DIR/app.zip"

# Ensure application directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "Creating application directory: $APP_DIR" >> "$LOG_FILE"
    sudo mkdir -p "$APP_DIR"
    sudo chmod 755 "$APP_DIR"
fi

# Extract app.zip
if [ -f "$APP_ZIP" ]; then
    echo "Extracting application files from $APP_ZIP to $APP_DIR..." >> "$LOG_FILE"
    sudo unzip -o "$APP_ZIP" -d "$APP_DIR" >> "$LOG_FILE" 2>&1
else
    echo "Error: app.zip not found at $APP_ZIP" >> "$LOG_FILE"
    exit 1
fi

# Install dependencies
REQ_FILE="$APP_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    echo "Installing dependencies from $REQ_FILE..." >> "$LOG_FILE"
    sudo pip3 install -r "$REQ_FILE" >> "$LOG_FILE" 2>&1
else
    echo "Error: requirements.txt not found in $APP_DIR" >> "$LOG_FILE"
    exit 1
fi

echo "Dependencies installed successfully." >> "$LOG_FILE"
exit 0