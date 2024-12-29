#!/bin/bash
echo "Setting up Gunicorn service..." >> /var/log/codedeploy_gunicorn_service.log

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

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and start Gunicorn
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn

# Check service status
if systemctl status gunicorn &> /dev/null; then
  echo "Gunicorn service started successfully." >> /var/log/codedeploy_gunicorn_service.log
else
  echo "Gunicorn service failed to start." >> /var/log/codedeploy_gunicorn_service.log
  exit 1
fi
