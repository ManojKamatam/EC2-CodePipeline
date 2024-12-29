#!/bin/bash
echo "Installing Gunicorn..." >> /var/log/codedeploy_gunicorn_install.log
sudo yum install -y gunicorn >> /var/log/codedeploy_gunicorn_install.log 2>&1
if ! command -v gunicorn &> /dev/null; then
  echo "Failed to install Gunicorn." >> /var/log/codedeploy_gunicorn_install.log
  exit 1
fi
echo "Gunicorn installed successfully." >> /var/log/codedeploy_gunicorn_install.log
