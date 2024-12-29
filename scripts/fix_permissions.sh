#!/bin/bash
DEPLOY_DIR=$(find /opt/codedeploy-agent/deployment-root/ -name "deployment-archive" -type d | head -n 1)
if [ -z "$DEPLOY_DIR" ]; then
    echo "Deployment directory not found."
    exit 1
fi

chmod +x "$DEPLOY_DIR/scripts/"*.sh
