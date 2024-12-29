#!/bin/bash

echo "Installing application dependencies..." >> /var/log/codedeploy_dependencies.log

# Ensure pip is available
if ! command -v pip3 &> /dev/null; then
  echo "pip3 is not installed. Installing..." >> /var/log/codedeploy_dependencies.log
  sudo yum install -y python3-pip >> /var/log/codedeploy_dependencies.log 2>&1
fi

# Install dependencies from requirements.txt
sudo pip3 install -r /var/www/myapp/requirements.txt >> /var/log/codedeploy_dependencies.log 2>&1

# Verify Flask installation
if ! python3 -c "import flask" &> /dev/null; then
  echo "Flask installation failed." >> /var/log/codedeploy_dependencies.log
  exit 1
fi

echo "Application dependencies installed successfully." >> /var/log/codedeploy_dependencies.log
