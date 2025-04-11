#!/bin/bash
# set -e

# chown -R clamav:clamav /var/lib/clamav /var/run/clamav
# chmod -R 775 /var/lib/clamav

# if [ ! -f "/var/lib/clamav/main.cvd" ]; then \

#     wget -q --tries=3 --timeout=15 \
#         -O /var/lib/clamav/main.cvd \
#         http://db.cn.clamav.net/main.cvd && \
#         chown clamav:clamav /var/lib/clamav/main.cvd;
# fi

# if [ ! -f "/var/lib/clamav/daily.cvd" ]; then
  
#     freshclam --stdout --no-warnings
# fi

# sudo -u clamav freshclam --daemon &
# sudo -u clamav clamd &

# sleep 5

# cat <<EOF > /etc/msmtprc
# account default
# host ${SMTP_HOST}
# port ${SMTP_PORT}
# from ${SMTP_USER}
# auth on
# user ${SMTP_USER}
# password ${SMTP_PASSWORD}
# tls on
# tls_starttls on
# logfile /var/log/msmtp.log
# EOF
    
# exec /Scripts/ScanAndAlert.sh

echo "FIXME - Entry.sh"