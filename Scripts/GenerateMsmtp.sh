#!/bin/bash

# Generate msmtprc config using env vars
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

# Secure the file
chmod 600 /etc/msmtprc && more /etc/msmtprc