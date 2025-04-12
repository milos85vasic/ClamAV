#!/bin/bash
set -e

sh /Scripts/VPN.sh

while ! ip addr show tun0 >/dev/null 2>&1; do
  
  sleep 1
done

echo "Forcing traffic through the VPN"

OLD_GW=$(ip route show default | awk '{print $3}')

sudo ip route del default 2>/dev/null || true

if ! sudo ip route add default dev tun0; then
  
    echo "Failed to set VPN as default route"
    exit 1
fi

echo "nameserver 1.1.1.1" > /etc/resolv.conf

echo "VPN routing configured: " && ip route show

echo "ScriptedUpdates no" > /usr/local/etc/freshclam.conf && \
    echo "DatabaseDirectory /usr/local/share/clamav" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror https://db.cn.clamav.net" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://db.by.clamav.net" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://db.kz.clamav.net" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://clamav.belnet.be" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://clamav.by" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://ftp.swin.edu.au/sanesecurity" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://clamavdb.heanet.ie/sanesecurity" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/jurlbl.ndb" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/jurlbla.ndb" >> /usr/local/etc/freshclam.conf && \
    echo "Checks 24" >> /usr/local/etc/freshclam.conf && \
    echo "Generated the '/usr/local/etc/freshclam.conf': " && cat /usr/local/etc/freshclam.conf
    
sudo -u clamav freshclam --verbose && \
    sudo -u clamav clamscan --debug --infected --no-summary /usr/local/share/clamav/ && \
    sudo -u clamav clamscan --version

echo "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-TEST-FILE!$H+H*" > test.txt
echo "Test file content:"
cat test.txt
echo ""

if sudo -u clamav clamscan --debug --infected --no-summary test.txt | grep -q "EICAR-Test-File"; then
    
    echo "✅ EICAR test file detected (ClamAV working)"
    rm -f test.txt
    
else
    
    echo "❌ ERROR: EICAR test file NOT detected (ClamAV misconfigured)"
    
    echo "Debug info:"
    sudo -u clamav clamscan --version
    ls -la /var/lib/clamav/
    exit 1
fi
     
echo "TODO: Further"

# validate_cvd() {
    
#     if ! clamscan --debug --infected --no-summary "$1"; then
    
#         echo "Corrupted CVD detected: $(basename "$1")" >&2
#         rm -f "$1"
#         return 1
#     fi
# }

# mkdir -p /var/lib/clamav/tmp
# chown -R clamav:clamav /var/lib/clamav
# chmod -R 775 /var/lib/clamav

# for cvd in /var/lib/clamav/*.cvd; do
    
#     [ -f "$cvd" ] && validate_cvd "$cvd"
# done

# if [ ! -f "/var/lib/clamav/main.cvd" ] || \
#    [ ! -f "/var/lib/clamav/daily.cvd" ] || \
#    [ ! -f "/var/lib/clamav/bytecode.cvd" ]; then
    
#     echo "Downloading fresh databases..."
#     sudo -u clamav freshclam --stdout --no-warnings
# fi

# sudo -u clamav freshclam --daemon &
# sudo -u clamav clamd &

# while ! [ -S /var/run/clamav/clamd.ctl ]; do sleep 1; done

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

# SCRIPT="/Scripts/ScanAndAlert.sh"

# if test -e "$SCRIPT"; then

#     echo "Script ScanAndAlert.sh found at $SCRIPT"
#     exec "$SCRIPT" &

# else
    
#     echo "Script ScanAndAlert.sh not found at $SCRIPT"
#     exit 1
# fi

tail -f /var/log/clamav/clamav.log
