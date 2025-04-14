#!/bin/bash
set -e

[ -d /etc/msmtprc ] && sudo rm -rf /etc/ssmtp/ssmtp.conf

sudo tee /etc/ssmtp/ssmtp.conf >/dev/null <<EOF
root=${SMTP_USER}
mailhub=${SMTP_HOST}:${SMTP_PORT}
AuthUser=${SMTP_USER}
AuthPass=${SMTP_PASSWORD}
UseTLS=YES
UseSTARTTLS=YES
EOF

sudo chmod 600 /etc/ssmtp/ssmtp.conf
sudo chown root:root /etc/ssmtp/ssmtp.conf

echo "-----------------------------------------"
echo "ssmtp configuration: "
cat /etc/ssmtp/ssmtp.conf
echo "----------------------------------------"

if ! echo "Test email from ClamAV" | ssmtp "${ALERT_EMAIL}"; then
  
    echo "❌ ERROR: Failed to send the test email"
    exit 1
fi

echo "✅ Test email sent successfully to ${ALERT_EMAIL}"
exit 0