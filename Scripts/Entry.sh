#!/bin/bash

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

if [ ! -f "/var/lib/clamav/main.cvd" ]; then
    
    echo "Downloading initial ClamAV database..."
    freshclam --stdout
fi

freshclam --daemon --checks=1 --stdout && \
    clamd && \
    /Scripts/ScanAndAlert.sh