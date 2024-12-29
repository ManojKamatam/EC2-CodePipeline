#!/bin/bash

LOG_FILE="/var/log/codedeploy_dependencies.log"
APP_DIR="/var/www/myapp"
VENV_DIR="$APP_DIR/venv"
REQ_FILE="$APP_DIR/requirements.txt"

echo "Starting dependency installation..." >> "$LOG_FILE"

# Step 1: Ensure the application directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "Application directory $APP_DIR does not exist. Exiting." >> "$LOG_FILE"
    exit 1
fi

# Step 2: Ensure the virtual environment exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in $VENV_DIR..." >> "$LOG_FILE"
    python3 -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment. Exiting." >> "$LOG_FILE"
        exit 1
    fi
fi

# Step 3: Activate the virtual environment
echo "Activating virtual environment..." >> "$LOG_FILE"
source "$VENV_DIR/bin/activate"
if [ $? -ne 0 ]; then
    echo "Failed to activate virtual environment. Exiting." >> "$LOG_FILE"
    exit 1
fi

# Step 4: Install dependencies
if [ -f "$REQ_FILE" ]; then
    echo "Installing dependencies from $REQ_FILE..." >> "$LOG_FILE"
    pip install -r "$REQ_FILE" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "Failed to install dependencies from $REQ_FILE. Exiting." >> "$LOG_FILE"
        deactivate
        exit 1
    fi
else
    echo "requirements.txt not found. Installing Flask directly..." >> "$LOG_FILE"
    pip install Flask >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "Failed to install Flask. Exiting." >> "$LOG_FILE"
        deactivate
        exit 1
    fi
fi

# Step 5: Verify Flask installation
echo "Verifying Flask installation..." >> "$LOG_FILE"
python3 -c "import flask; print('Flask installed successfully!')" >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "Flask is not installed properly. Exiting." >> "$LOG_FILE"
    deactivate
    exit 1
fi

# Step 6: Ensure the application runs (optional)
echo "Testing application startup..." >> "$LOG_FILE"
python3 "$APP_DIR/app.py" >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "Application failed to start. Check your app.py script for issues." >> "$LOG_FILE"
    deactivate
    exit 1
fi

echo "Dependencies installed and application verified successfully." >> "$LOG_FILE"
deactivate
exit 0
