#!/bin/bash
LOG_FILE="/var/log/codedeploy_restart.log"

echo "Restarting Gunicorn server..." >> $LOG_FILE

# Ensure Gunicorn is installed and Python path is correct
if ! command -v gunicorn &> /dev/null; then
  echo "Gunicorn not found. Installing..." >> $LOG_FILE
  pip3 install gunicorn >> $LOG_FILE 2>&1
fi

# Restart Gunicorn
if systemctl status gunicorn &> /dev/null; then
  sudo systemctl restart gunicorn >> $LOG_FILE 2>&1
  echo "Gunicorn restarted successfully." >> $LOG_FILE
else
  echo "Gunicorn service not found or failed to start." >> $LOG_FILE
  exit 1
fi
