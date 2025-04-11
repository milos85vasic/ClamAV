#!/bin/bash

# Load environment variables (fallback to defaults)
SMTP_HOST=${SMTP_HOST:-"smtp.gmail.com"}
SMTP_PORT=${SMTP_PORT:-"587"}
ALERT_EMAIL=${ALERT_EMAIL:-"your@email.com"}
LOG_FILE="/var/log/clamav/scan.log"

# Run scan
clamscan -r --move=/quarantine /scandir > "$LOG_FILE" 2>&1

# Send alerts
if grep -q "FOUND" "$LOG_FILE"; then
  
  echo "Infected files found!" | mail -s "🚨 ClamAV Alert" "$ALERT_EMAIL" -A "$LOG_FILE"

elif grep -q "ERROR" "$LOG_FILE"; then
  
  echo "Scan error occurred!" | mail -s "⚠️ ClamAV Error" "$ALERT_EMAIL" -A "$LOG_FILE"
fi