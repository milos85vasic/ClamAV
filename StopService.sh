#!/bin/bash

SERVICE_NAME="clamav-monitor"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

if systemctl is-active --quiet "$SERVICE_NAME"; then
    
    echo "Stopping the $SERVICE_NAME service..."
    sudo systemctl stop "$SERVICE_NAME"
fi

if [ -f "$SERVICE_FILE" ]; then
    
    echo "Removing the existing $SERVICE_FILE..."
    sudo rm "$SERVICE_FILE"
fi

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
