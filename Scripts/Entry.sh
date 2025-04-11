#!/bin/bash

if [ ! -f "/var/lib/clamav/daily.cvd" ]; then
  
    echo "Initializing ClamAV databases..."
    freshclam --stdout --no-warnings
fi

freshclam --daemon --stdout &
clamd &

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
    
/Scripts/ScanAndAlert.sh