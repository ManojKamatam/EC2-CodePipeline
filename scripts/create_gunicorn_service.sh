#!/bin/bash

LOG_FILE="/var/log/codedeploy_gunicorn_service.log"
echo "Setting up Gunicorn service..." >> "$LOG_FILE"

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

# Reload systemd and start Gunicorn
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl restart gunicorn

# Check service status
if systemctl status gunicorn &> /dev/null; then
  echo "Gunicorn service started successfully." >> "$LOG_FILE"
else
  echo "Gunicorn service failed to start." >> "$LOG_FILE"
  exit 1
fi
