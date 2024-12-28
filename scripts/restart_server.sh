#!/bin/bash
echo "Restarting Gunicorn server..." >> /var/log/codedeploy_restart.log
sudo systemctl restart gunicorn >> /var/log/codedeploy_restart.log 2>&1
