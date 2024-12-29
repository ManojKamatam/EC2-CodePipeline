#!/bin/bash

LOG_FILE="/var/log/codedeploy_dependencies.log"
echo "Installing application dependencies..." >> "$LOG_FILE"

# Ensure pip3 is installed
if ! command -v pip3 &> /dev/null; then
  echo "pip3 is not installed. Installing..." >> "$LOG_FILE"
  sudo yum install -y python3-pip >> "$LOG_FILE" 2>&1
  if [ $? -ne 0 ]; then
    echo "Error installing pip3." >> "$LOG_FILE"
    exit 1
  fi
fi

# Ensure the application directory exists
APP_DIR="/var/www/myapp"
if [ ! -d "$APP_DIR" ]; then
  echo "Creating application directory: $APP_DIR" >> "$LOG_FILE"
  sudo mkdir -p "$APP_DIR"
  sudo chown ec2-user:ec2-user "$APP_DIR"
fi

# Install dependencies from requirements.txt
REQ_FILE="$APP_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
  echo "Installing dependencies from $REQ_FILE..." >> "$LOG_FILE"
  sudo pip3 install -r "$REQ_FILE" >> "$LOG_FILE" 2>&1
  if [ $? -ne 0 ]; then
    echo "Error installing dependencies from requirements.txt" >> "$LOG_FILE"
    exit 1
  fi
else
  echo "requirements.txt not found in $APP_DIR." >> "$LOG_FILE"
  exit 1
fi

# Verify Flask installation
if ! python3 -c "import flask" &> /dev/null; then
  echo "Flask installation verification failed." >> "$LOG_FILE"
  exit 1
fi

echo "Application dependencies installed successfully." >> "$LOG_FILE"
exit 0
