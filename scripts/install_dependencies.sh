#!/bin/bash
LOG_FILE="/var/log/codedeploy_install.log"
echo "Installing application dependencies..." >> $LOG_FILE

# Ensure Python 3 is being used
python3 --version >> $LOG_FILE 2>&1 || { echo "Python 3 not found!" >> $LOG_FILE; exit 1; }

# Install pip if not already installed
if ! command -v pip3 &> /dev/null; then
  echo "Installing pip..." >> $LOG_FILE
  sudo yum install -y python3-pip >> $LOG_FILE 2>&1
fi

# Install dependencies
if [ -f "/var/www/myapp/requirements.txt" ]; then
  pip3 install -r /var/www/myapp/requirements.txt >> $LOG_FILE 2>&1
else
  echo "requirements.txt not found in /var/www/myapp" >> $LOG_FILE
  exit 1
fi

echo "Dependencies installed successfully." >> $LOG_FILE
