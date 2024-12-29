#!/bin/bash

# Log the permissions fix process
LOG_FILE="/var/log/codedeploy_permissions.log"
echo "Fixing permissions and preparing deployment..." >> $LOG_FILE

# Find the deployment directory
DEPLOY_DIR=$(find /opt/codedeploy-agent/deployment-root/ -name "deployment-archive" -type d | head -n 1)
if [ -z "$DEPLOY_DIR" ]; then
    echo "Deployment directory not found." >> $LOG_FILE
    exit 1
fi

# Ensure the scripts directory exists and fix permissions
if [ -d "$DEPLOY_DIR/scripts" ]; then
  chmod +x "$DEPLOY_DIR/scripts/"*.sh
  echo "Permissions set for scripts in $DEPLOY_DIR/scripts" >> $LOG_FILE
else
  echo "Scripts directory does not exist in $DEPLOY_DIR. Skipping script permission fixes." >> $LOG_FILE
fi

# Ensure the deployment directory exists and extract app.zip
if [ -d "/var/www/myapp" ]; then
  echo "Extracting app.zip to /var/www/myapp..." >> $LOG_FILE
  unzip -o "$DEPLOY_DIR/app.zip" -d /var/www/myapp/ >> $LOG_FILE 2>&1
  chmod -R 755 /var/www/myapp
  echo "Permissions fixed for /var/www/myapp" >> $LOG_FILE
else
  echo "Application directory does not exist. Creating it..." >> $LOG_FILE
  mkdir -p /var/www/myapp
  unzip -o "$DEPLOY_DIR/app.zip" -d /var/www/myapp/ >> $LOG_FILE 2>&1
  chmod -R 755 /var/www/myapp
  echo "App.zip extracted and permissions fixed for /var/www/myapp" >> $LOG_FILE
fi
