#!/bin/bash
set -e

validate_cvd() {
    if ! clamscan --debug --infected --no-summary "$1"; then
        echo "Corrupted CVD detected: $(basename "$1")" >&2
        rm -f "$1"
        return 1
    fi
}

mkdir -p /var/lib/clamav/tmp
chown -R clamav:clamav /var/lib/clamav
chmod -R 775 /var/lib/clamav

for cvd in /var/lib/clamav/*.cvd; do
    [ -f "$cvd" ] && validate_cvd "$cvd"
done

if [ ! -f "/var/lib/clamav/main.cvd" ] || \
   [ ! -f "/var/lib/clamav/daily.cvd" ] || \
   [ ! -f "/var/lib/clamav/bytecode.cvd" ]; then
    echo "Downloading fresh databases..."
    sudo -u clamav freshclam --stdout --no-warnings
fi

sudo -u clamav freshclam --daemon &
sudo -u clamav clamd &

while ! [ -S /var/run/clamav/clamd.ctl ]; do sleep 1; done

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

SCRIPT="/Scripts/ScanAndAlert.sh"

if test -e "$SCRIPT"; then

    echo "Script ScanAndAlert.sh found at $SCRIPT"
    exec "$SCRIPT" &

else
    
    echo "Script ScanAndAlert.sh not found at $SCRIPT"
    exit 1
fi

tail -f /var/log/clamav/clamav.log
