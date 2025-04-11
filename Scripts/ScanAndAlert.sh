#!/bin/sh

LOG_FILE="/var/log/clamav/scan.log"
EMAIL="your@email.com"

# Run scan
clamscan -r --move=/quarantine /scandir > "$LOG_FILE" 2>&1

# Check for infections
if grep -q "FOUND" "$LOG_FILE"; then
  mail -s "🚨 ClamAV Infection Alert" "$EMAIL" < "$LOG_FILE"
fi

# Check for errors
if grep -q "ERROR" "$LOG_FILE"; then
  mail -s "⚠️ ClamAV Critical Error" "$EMAIL" < "$LOG_FILE"
fi