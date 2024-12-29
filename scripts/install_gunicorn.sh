#!/bin/bash
echo "Installing Gunicorn..." >> /var/log/codedeploy_gunicorn_install.log

# Ensure pip is installed
if ! command -v pip3 &> /dev/null; then
  echo "Installing pip3..." >> /var/log/codedeploy_gunicorn_install.log
  sudo yum install -y python3-pip >> /var/log/codedeploy_gunicorn_install.log 2>&1
fi

# Install Gunicorn
sudo pip3 install gunicorn >> /var/log/codedeploy_gunicorn_install.log 2>&1

# Check if Gunicorn is installed
if ! command -v gunicorn &> /dev/null; then
  echo "Gunicorn installation failed." >> /var/log/codedeploy_gunicorn_install.log
  exit 1
fi

echo "Gunicorn installed successfully." >> /var/log/codedeploy_gunicorn_install.log
