#!/bin/bash

LOG_FILE="/var/log/codedeploy_dependencies.log"
echo "Installing application dependencies..." >> "$LOG_FILE"

# Ensure pip3 is installed
if ! command -v pip3 &> /dev/null; then
  echo "pip3 is not installed. Installing..." >> "$LOG_FILE"
  sudo yum install -y python3-pip >> "$LOG_FILE" 2>&1
fi

# Install dependencies from requirements.txt
if [ -f "/var/www/myapp/requirements.txt" ]; then
  sudo pip3 install -r /var/www/myapp/requirements.txt >> "$LOG_FILE" 2>&1
else
  echo "requirements.txt not found in /var/www/myapp." >> "$LOG_FILE"
  exit 1
fi

# Verify Flask installation
if ! python3 -c "import flask" &> /dev/null; then
  echo "Flask installation failed." >> "$LOG_FILE"
  exit 1
fi

echo "Dependencies installed successfully." >> "$LOG_FILE"
