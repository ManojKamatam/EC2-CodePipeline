#!/bin/bash

# Log the installation process
echo "Installing Gunicorn..." >> /var/log/codedeploy_gunicorn_install.log

# Ensure pip is installed
if ! command -v pip &> /dev/null; then
  echo "Installing pip..." >> /var/log/codedeploy_gunicorn_install.log
  sudo yum install -y python3-pip >> /var/log/codedeploy_gunicorn_install.log 2>&1
fi

# Install Gunicorn using pip
sudo pip3 install gunicorn >> /var/log/codedeploy_gunicorn_install.log 2>&1

# Verify Gunicorn installation
if ! command -v gunicorn &> /dev/null; then
  echo "Failed to install Gunicorn." >> /var/log/codedeploy_gunicorn_install.log
  exit 1
fi

echo "Gunicorn installed successfully." >> /var/log/codedeploy_gunicorn_install.log
