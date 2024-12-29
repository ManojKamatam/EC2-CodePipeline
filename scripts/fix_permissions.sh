#!/bin/bash

# Find the correct deployment directory dynamically
DEPLOY_DIR=$(find /opt/codedeploy-agent/deployment-root/ -name "deployment-archive" -type d | head -n 1)

if [ -z "$DEPLOY_DIR" ]; then
  echo "Deployment directory not found."
  exit 1
fi

echo "Deployment directory found: $DEPLOY_DIR"

# Make all scripts executable
chmod +x "$DEPLOY_DIR/scripts/"*.sh
