#!/bin/bash
# Ensure the directory exists before applying permissions
if [ -d "/opt/codedeploy-agent/deployment-root/*/deployment-archive/scripts/" ]; then
    chmod +x /opt/codedeploy-agent/deployment-root/*/deployment-archive/scripts/*.sh
else
    echo "Scripts directory does not exist."
    exit 1
fi
