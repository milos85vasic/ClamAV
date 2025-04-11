#!/bin/sh

cat <<EOF > /etc/msmtprc
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

chmod 600 /etc/msmtprc

echo "Test email from ClamAV" | mailx -s "ClamAV Setup Test" ${ALERT_EMAIL}