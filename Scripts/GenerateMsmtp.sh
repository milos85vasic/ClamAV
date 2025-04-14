#!/bin/bash
set -e

[ -d /etc/msmtprc ] && sudo rm -rf /etc/msmtprc

sudo tee /etc/msmtprc >/dev/null <<EOF
account default
host ${SMTP_HOST}
port ${SMTP_PORT}
from ${SMTP_USER}
auth on
user ${SMTP_USER}
password ${SMTP_PASSWORD}
tls on
tls_starttls on
logfile /var/log/msmtp.log
EOF

sudo chmod 600 /etc/msmtprc
sudo chown root:root /etc/msmtprc

echo "Test email from ClamAV" | mailx -s "ClamAV Setup Test" "${ALERT_EMAIL}"