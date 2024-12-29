#!/bin/bash

# Log the restart process
echo "Restarting Gunicorn server..." >> /var/log/codedeploy_restart.log

# Ensure PYTHONPATH includes the application directory
export PYTHONPATH=/var/www/myapp/package:$PYTHONPATH
echo "PYTHONPATH set to: $PYTHONPATH" >> /var/log/codedeploy_restart.log

# Restart Gunicorn
if systemctl status gunicorn &> /dev/null; then
  sudo systemctl restart gunicorn >> /var/log/codedeploy_restart.log 2>&1
  echo "Gunicorn restarted successfully" >> /var/log/codedeploy_restart.log
else
  echo "Gunicorn service not found or failed to restart." >> /var/log/codedeploy_restart.log
  exit 1
fi
