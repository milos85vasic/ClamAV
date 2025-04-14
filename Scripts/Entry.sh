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
    echo "DatabaseDirectory /var/lib/clamav" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror https://db.cn.clamav.net" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://db.by.clamav.net" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://db.kz.clamav.net" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://clamav.belnet.be" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://clamav.by" >> /usr/local/etc/freshclam.conf && \
    echo "Checks 24" >> /usr/local/etc/freshclam.conf && \
    echo "Generated the '/usr/local/etc/freshclam.conf': " && cat /usr/local/etc/freshclam.conf

sudo chown -R clamav:clamav /var/lib/clamav /usr/local/share/clamav
sudo -u clamav freshclam --verbose && sudo -u clamav clamscan --version
sudo rm -f /var/lib/clamav/ksp.*

echo "ClamAV configuration: "
echo "----------------------------------------"
grep -E '(AlgorithmicDetection|Heuristic|Target)' /etc/clamav/clamd.conf
echo "----------------------------------------"

curl -O https://secure.eicar.org/eicar.com.txt

if ! test -e /eicar.com.txt; then
    
    echo "ERROR: EICAR test asset file not found"
    exit 1
fi

echo "Test file content:"
cat /eicar.com.txt
echo ""

if sudo -u clamav clamscan --debug --infected /eicar.com.txt | grep -q "Infected files: 1"; then
    
    echo "✅ EICAR test file detected (ClamAV working)"
    rm -f eicar.com.txt
    
else
    
    echo "❌ ERROR: EICAR test file NOT detected (ClamAV misconfigured)"
    
    echo "Debug info:"
    sudo -u clamav clamscan --version
    ls -la /var/lib/clamav/
    exit 1
fi

if ! sh /Scripts/Log.sh "Test log from ClamAV"; then
    
    echo "ERROR: Log.sh script failed"
    exit 1
fi

SCRIPT="/Scripts/ScanAndAlert.sh"

if test -e "$SCRIPT"; then

    echo "Script ScanAndAlert.sh found at $SCRIPT. Executing..."
    # exec "$SCRIPT" &

else
    
    echo "Script ScanAndAlert.sh not found at $SCRIPT"
    exit 1
fi

tail -f /var/log/clamav/clamav.log
