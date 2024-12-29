#!/bin/bash

# Log file
LOG_FILE="/var/log/codedeploy_permissions.log"
echo "Starting permission fixes and deployment preparation..." >> "$LOG_FILE"

# Find the deployment directory
DEPLOY_DIR=$(find /opt/codedeploy-agent/deployment-root/ -name "deployment-archive" -type d | head -n 1)
if [ -z "$DEPLOY_DIR" ]; then
    echo "Error: Deployment directory not found." >> "$LOG_FILE"
    exit 1
fi
echo "Deployment directory located at: $DEPLOY_DIR" >> "$LOG_FILE"

# Fix permissions for scripts
if [ -d "$DEPLOY_DIR/scripts" ]; then
    chmod +x "$DEPLOY_DIR/scripts/"*.sh
    echo "Script permissions fixed in $DEPLOY_DIR/scripts" >> "$LOG_FILE"
else
    echo "Warning: Scripts directory does not exist in $DEPLOY_DIR. Skipping script permission fixes." >> "$LOG_FILE"
fi

# Ensure the deployment directory exists and extract app.zip
if [ -d "/var/www/myapp" ]; then
    echo "Application directory exists. Extracting app.zip..." >> "$LOG_FILE"
else
    echo "Application directory does not exist. Creating /var/www/myapp..." >> "$LOG_FILE"
    mkdir -p /var/www/myapp
    chmod 755 /var/www/myapp
fi

if [ -f "$DEPLOY_DIR/app.zip" ]; then
    echo "Extracting app.zip to /var/www/myapp..." >> "$LOG_FILE"
    unzip -o "$DEPLOY_DIR/app.zip" -d /var/www/myapp/ >> "$LOG_FILE" 2>&1
    chmod -R 755 /var/www/myapp
    echo "App.zip extracted and permissions fixed for /var/www/myapp" >> "$LOG_FILE"
else
    echo "Error: app.zip not found in $DEPLOY_DIR. Deployment cannot proceed." >> "$LOG_FILE"
    exit 1
fi

echo "Permission fixes and deployment preparation completed successfully." >> "$LOG_FILE"
exit 0
