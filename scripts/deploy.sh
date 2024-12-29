#!/bin/bash

APP_DIR="/var/www/myapp"
GUNICORN_SERVICE="/etc/systemd/system/gunicorn.service"

# Create Gunicorn service file
if [ ! -f "$GUNICORN_SERVICE" ]; then
    echo "Creating Gunicorn systemd service..."
    sudo tee $GUNICORN_SERVICE > /dev/null <<EOL
[Unit]
Description=Gunicorn instance to serve myapp
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=$APP_DIR
ExecStart=$APP_DIR/venv/bin/gunicorn --workers 3 --bind unix:$APP_DIR/gunicorn.sock app:app

[Install]
WantedBy=multi-user.target
EOL
    sudo systemctl daemon-reload
    sudo systemctl enable gunicorn
fi

# Start Gunicorn
echo "Starting Gunicorn service..."
sudo systemctl restart gunicorn

# Configure and restart Nginx (optional)
if [ -f "/etc/nginx/sites-available/myapp" ]; then
    echo "Nginx configuration already exists."
else
    echo "Configuring Nginx..."
    sudo tee /etc/nginx/sites-available/myapp > /dev/null <<EOL
server {
    listen 80;
    server_name your_server_ip_or_domain;

    location / {
        proxy_pass http://unix:$APP_DIR/gunicorn.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL
    sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled
    sudo nginx -t && sudo systemctl restart nginx
fi

echo "Deployment completed!"
