#!/bin/bash

LOG_FILE="/var/log/codedeploy_gunicorn_service.log"
echo "Setting up Gunicorn service..." >> "$LOG_FILE"

# Ensure Gunicorn is installed
if ! command -v gunicorn &> /dev/null; then
  echo "Gunicorn is not installed. Installing..." >> "$LOG_FILE"
  sudo pip3 install gunicorn >> "$LOG_FILE" 2>&1
  if [ $? -ne 0 ]; then
    echo "Error installing Gunicorn." >> "$LOG_FILE"
    exit 1
  fi
fi

# Create Gunicorn service file
sudo tee /etc/systemd/system/gunicorn.service > /dev/null <<EOL
[Unit]
Description=Gunicorn daemon for a Python application
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/var/www/myapp
ExecStart=/usr/local/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 app:app
Environment="PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize the new service
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
  echo "Error reloading systemd." >> "$LOG_FILE"
  exit 1
fi

# Enable and start the Gunicorn service
sudo systemctl enable gunicorn >> "$LOG_FILE" 2>&1
sudo systemctl start gunicorn >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
  echo "Failed to start Gunicorn service." >> "$LOG_FILE"
  exit 1
fi

# Verify Gunicorn service status
if systemctl status gunicorn &> /dev/null; then
  echo "Gunicorn service started successfully." >> "$LOG_FILE"
else
  echo "Gunicorn service failed to start." >> "$LOG_FILE"
  exit 1
fi
exit 0
