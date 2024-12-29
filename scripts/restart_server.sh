#!/bin/bash

LOG_FILE="/var/log/codedeploy_restart.log"
echo "Restarting Gunicorn server..." >> "$LOG_FILE"

# Restart Gunicorn service
if systemctl status gunicorn &> /dev/null; then
  sudo systemctl restart gunicorn >> "$LOG_FILE" 2>&1
  if [ $? -eq 0 ]; then
    echo "Gunicorn restarted successfully." >> "$LOG_FILE"
  else
    echo "Failed to restart Gunicorn. Check the service logs." >> "$LOG_FILE"
    exit 1
  fi
else
  echo "Gunicorn service not found. Please check the setup." >> "$LOG_FILE"
  exit 1
fi
