#!/bin/bash

LOG_FILE="/var/log/codedeploy_dependencies.log"
APP_DIR="/var/www/myapp"
DEPLOY_ROOT="/opt/codedeploy-agent/deployment-root"

echo "Starting dependency installation..." >> "$LOG_FILE"

# Locate deployment-archive
DEPLOY_DIR=$(find "$DEPLOY_ROOT" -type d -name "deployment-archive" | head -n 1)
if [ -z "$DEPLOY_DIR" ]; then
    echo "Error: Deployment directory (deployment-archive) not found under $DEPLOY_ROOT." >> "$LOG_FILE"
    exit 1
fi

APP_ZIP="$DEPLOY_DIR/app.zip"

# Ensure application directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "Creating application directory: $APP_DIR" >> "$LOG_FILE"
    sudo mkdir -p "$APP_DIR"
    sudo chmod 755 "$APP_DIR"
fi

# Extract app.zip
if [ -f "$APP_ZIP" ]; then
    echo "Extracting application files from $APP_ZIP to $APP_DIR..." >> "$LOG_FILE"
    sudo unzip -o "$APP_ZIP" -d "$APP_DIR" >> "$LOG_FILE" 2>&1
else
    echo "Error: app.zip not found at $APP_ZIP" >> "$LOG_FILE"
    exit 1
fi

# Set up virtual environment
echo "Setting up virtual environment..." >> "$LOG_FILE"
python3 -m venv "$APP_DIR/venv"
source "$APP_DIR/venv/bin/activate"

# Install dependencies
REQ_FILE="$APP_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    echo "Installing dependencies from $REQ_FILE..." >> "$LOG_FILE"
    pip install -r "$REQ_FILE" >> "$LOG_FILE" 2>&1
else
    echo "requirements.txt not found. Installing Flask as fallback..." >> "$LOG_FILE"
    pip install flask >> "$LOG_FILE" 2>&1
fi

# Verify Flask installation
if ! python3 -c "import flask" &> /dev/null; then
    echo "Error: Flask installation failed." >> "$LOG_FILE"
    deactivate
    exit 1
fi

echo "Dependencies installed successfully." >> "$LOG_FILE"
deactivate
exit 0
