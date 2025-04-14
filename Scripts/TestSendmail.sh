#!/bin/bash
set -e

if ! echo "Test email from ClamAV Anti-Virus." | sendmail -f "$SMTP_USER" -m "Test email from ClamAV" -t "$SMTP_USER" -s smtp.yandex.ru:587 -xu "${ALERT_EMAIL}" -xp "$SMTP_PASSWORD"; then
  
    echo "❌ ERROR: Failed to send the test email"
    exit 1
fi

echo "✅ Test email sent successfully to ${ALERT_EMAIL}"
exit 0

