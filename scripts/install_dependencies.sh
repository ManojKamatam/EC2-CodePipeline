#!/bin/bash

LOG_FILE="/var/log/codedeploy_dependencies.log"
APP_DIR="/var/www/myapp"
DEPLOY_ROOT="/opt/codedeploy-agent/deployment-root"

echo "Installing application dependencies..." >> "$LOG_FILE"

# Locate the latest deployment directory dynamically
DEPLOY_DIR=$(find "$DEPLOY_ROOT" -mindepth 1 -maxdepth 1 -type d | sort -r | head -n 1)
if [ -z "$DEPLOY_DIR" ]; then
    echo "Error: Deployment directory not found." >> "$LOG_FILE"
    exit 1
fi

APP_ZIP="$DEPLOY_DIR/deployment-archive/app.zip"

# Ensure the application directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "Creating application directory: $APP_DIR" >> "$LOG_FILE"
    sudo mkdir -p "$APP_DIR"
    sudo chmod 755 "$APP_DIR"
else
    echo "Application directory already exists: $APP_DIR" >> "$LOG_FILE"
fi

# Extract app.zip to the application directory
if [ -f "$APP_ZIP" ]; then
    echo "Extracting application files from $APP_ZIP to $APP_DIR..." >> "$LOG_FILE"
    sudo unzip -o "$APP_ZIP" -d "$APP_DIR" >> "$LOG_FILE" 2>&1
else
    echo "Error: app.zip not found at $APP_ZIP" >> "$LOG_FILE"
    exit 1
fi

# Check for requirements.txt in the application directory
REQ_FILE="$APP_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    echo "requirements.txt found. Installing dependencies..." >> "$LOG_FILE"
else
    echo "Error: requirements.txt not found in $APP_DIR" >> "$LOG_FILE"
    exit 1
fi

# Ensure pip3 is installed
if ! command -v pip3 &> /dev/null; then
    echo "pip3 is not installed. Installing..." >> "$LOG_FILE"
    sudo yum install -y python3-pip >> "$LOG_FILE" 2>&1
fi

# Install dependencies from requirements.txt
sudo pip3 install -r "$REQ_FILE" >> "$LOG_FILE" 2>&1

# Verify Flask installation
if ! python3 -c "import flask" &> /dev/null; then
    echo "Flask installation failed." >> "$LOG_FILE"
    exit 1
fi

echo "Application dependencies installed successfully." >> "$LOG_FILE"
exit 0
